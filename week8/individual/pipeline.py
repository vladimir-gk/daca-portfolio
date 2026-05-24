"""
UrbanStyle | Week 8 | Roll D: Automation Script
Autor: Vladimir G
Kirjeldus: Terviklik pipeline — extract → transform → visualize → export
Käivitamine: python pipeline.py
"""

import logging
import os
import sys
import time
from datetime import datetime

# Failipõhine logimine (edasijõudnute tase)
os.makedirs("logs", exist_ok=True)
log_filename = f"logs/pipeline_{datetime.now().strftime('%Y%m%d')}.log"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler(log_filename, encoding="utf-8"),
        logging.StreamHandler(sys.stdout),
    ],
)
logger = logging.getLogger(__name__)


def run_pipeline(
    start_date: str = "2023-01-01",
    end_date: str = "2025-02-28",
    output_dir: str = "output",
) -> bool:
    """
    Käivitab tervikliku andmepipeline'i:
    1. Extract  — päri andmed Supabase'ist (Roll A)
    2. Transform — puhasta ja arvuta koondnäitajad (Roll B)
    3. Visualize — loo diagrammid (Roll C)
    4. Export    — salvesta tulemused failidesse (Roll C)

    Tagastab:
        bool: True kui kõik etapid õnnestusid, False kui esines viga
    """
    pipeline_start = time.time()
    logger.info("=" * 60)
    logger.info("UrbanStyle Pipeline käivitub")
    logger.info(f"Periood: {start_date} → {end_date}")
    logger.info("=" * 60)

    # ── ETAPP 1: EXTRACT ────────────────────────────────────────
    logger.info("[1/4] EXTRACT — Andmete pärimine algab")
    try:
        from data_fetcher import fetch_sales, fetch_customers, fetch_products

        df_sales = fetch_sales(start_date=start_date, end_date=end_date)
        df_customers = fetch_customers()
        df_products = fetch_products()

        if df_sales.empty:
            raise ValueError("fetch_sales tagastas tühja DataFrame'i!")

        logger.info(
            f"[1/4] EXTRACT lõpetatud: sales={df_sales.shape[0]}, "
            f"customers={df_customers.shape[0]}, products={df_products.shape[0]}"
        )

    except Exception as e:
        logger.error(f"[1/4] EXTRACT EBAÕNNESTUS: {e}")
        return False

    # ── ETAPP 2: TRANSFORM ──────────────────────────────────────
    logger.info("[2/4] TRANSFORM — Andmete töötlemine algab")
    try:
        from transform import (
            clean_data,
            calculate_weekly_aggregates,
            calculate_kpis,
            merge_datasets,
        )

        df_merged = merge_datasets(df_sales, df_customers)
        df_clean = clean_data(df_merged)

        if df_clean.empty:
            raise ValueError("clean_data tagastas tühja DataFrame'i!")

        df_weekly = calculate_weekly_aggregates(df_clean)
        kpis = calculate_kpis(df_clean)

        logger.info(
            f"[2/4] TRANSFORM lõpetatud: {df_clean.shape[0]} puhast rida, "
            f"{df_weekly.shape[0]} nädalat, käive={kpis['total_revenue']:,.0f} EUR"
        )

    except Exception as e:
        logger.error(f"[2/4] TRANSFORM EBAÕNNESTUS: {e}")
        return False

    # ── ETAPP 3: VISUALIZE ──────────────────────────────────────
    logger.info("[3/4] VISUALIZE — Diagrammide loomine algab")
    try:
        from visualize_export import create_weekly_chart, create_kpi_summary

        fig_weekly = create_weekly_chart(df_weekly)
        fig_kpis = create_kpi_summary(kpis)

        logger.info("[3/4] VISUALIZE lõpetatud: 2 diagrammi loodud")

    except Exception as e:
        logger.error(f"[3/4] VISUALIZE EBAÕNNESTUS: {e}")
        return False

    # ── ETAPP 4: EXPORT ─────────────────────────────────────────
    logger.info("[4/4] EXPORT — Failide salvestamine algab")
    try:
        from visualize_export import export_results, export_charts

        files = export_results(df_clean, output_dir=output_dir)
        charts = export_charts(fig_weekly, fig_kpis, output_dir=output_dir)

        all_files = {**files, **charts}
        logger.info(
            f"[4/4] EXPORT lõpetatud: {len(all_files)} faili → {output_dir}/"
        )
        for name, path in all_files.items():
            logger.info(f"  → {name}: {path}")

    except Exception as e:
        logger.error(f"[4/4] EXPORT EBAÕNNESTUS: {e}")
        return False

    # ── KOKKUVÕTE ───────────────────────────────────────────────
    elapsed = time.time() - pipeline_start
    logger.info("=" * 60)
    logger.info(f"Pipeline ÕNNESTUS ({elapsed:.1f}s)")
    logger.info(f"Kogutulu:          {kpis['total_revenue']:,.2f} EUR")
    logger.info(f"Unikaalseid kliente: {kpis['unique_customers']}")
    logger.info(f"Keskmine tellimus:  {kpis['avg_order_value']:.2f} EUR")
    logger.info(f"Logifail:          {log_filename}")
    logger.info("=" * 60)
    return True


if __name__ == "__main__":
    success = run_pipeline(
        start_date="2023-01-01",
        end_date="2025-02-28",
        output_dir="output",
    )
    sys.exit(0 if success else 1)
