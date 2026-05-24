"""
UrbanStyle | Week 8 | Roll C: Visualization + Saving
Autor: Vladimir G
Kirjeldus: Plotly diagrammid + CSV ja HTML eksport ajatempliga
"""

import logging
import os
from datetime import datetime

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

logger = logging.getLogger(__name__)

BRAND_TEAL = "#009B8D"
BRAND_NAVY = "#1A1A2E"


def create_weekly_chart(df_weekly: pd.DataFrame) -> go.Figure:
    """
    Loob Plotly joondiagrammi nädalastest tululiikumistest.

    Parameetrid:
        df_weekly (pd.DataFrame): Nädalased koondandmed (week, revenue)

    Tagastab:
        plotly.graph_objects.Figure
    """
    try:
        logger.info("create_weekly_chart algab")

        fig = px.line(
            df_weekly,
            x="week",
            y="revenue",
            title="UrbanStyle — Nädalane müügitulu",
            labels={"week": "Nädal", "revenue": "Tulu (EUR)"},
            color_discrete_sequence=[BRAND_TEAL],
        )

        # Viitejoon: keskmine nädalatulu
        avg_revenue = df_weekly["revenue"].mean()
        fig.add_hline(
            y=avg_revenue,
            line_dash="dash",
            line_color="gray",
            annotation_text=f"Keskmine: {avg_revenue:,.0f} EUR",
            annotation_position="right",
        )

        # Parim nädal annotatsioon
        best_week = df_weekly.loc[df_weekly["revenue"].idxmax()]
        fig.add_annotation(
            x=best_week["week"],
            y=best_week["revenue"],
            text=f"Parim nädal:<br>{best_week['revenue']:,.0f} EUR",
            showarrow=True,
            arrowhead=2,
            ax=0,
            ay=-40,
            font=dict(color=BRAND_TEAL, size=11),
        )

        fig.update_layout(
            plot_bgcolor="white",
            xaxis=dict(gridcolor="#f0f0f0"),
            yaxis=dict(gridcolor="#f0f0f0"),
            font=dict(family="Arial"),
        )

        logger.info("create_weekly_chart lõpetatud")
        return fig

    except Exception as e:
        logger.error(f"create_weekly_chart viga: {e}")
        raise


def create_kpi_summary(kpis: dict) -> go.Figure:
    """
    Loob Plotly KPI indicator kaardid.

    Parameetrid:
        kpis (dict): calculate_kpis() väljund

    Tagastab:
        plotly.graph_objects.Figure
    """
    try:
        logger.info("create_kpi_summary algab")

        fig = go.Figure()

        fig.add_trace(go.Indicator(
            mode="number",
            value=kpis["total_revenue"],
            title={"text": "Kogutulu (EUR)"},
            number={"prefix": "€", "valueformat": ",.0f"},
            domain={"row": 0, "column": 0},
        ))
        fig.add_trace(go.Indicator(
            mode="number",
            value=kpis["unique_customers"],
            title={"text": "Unikaalseid kliente"},
            domain={"row": 0, "column": 1},
        ))
        fig.add_trace(go.Indicator(
            mode="number",
            value=kpis["avg_order_value"],
            title={"text": "Keskmine tellimus (EUR)"},
            number={"prefix": "€", "valueformat": ",.2f"},
            domain={"row": 0, "column": 2},
        ))
        fig.add_trace(go.Indicator(
            mode="number",
            value=kpis["total_orders"],
            title={"text": "Tellimusi kokku"},
            domain={"row": 0, "column": 3},
        ))

        fig.update_layout(
            title="UrbanStyle — KPI kokkuvõte",
            grid={"rows": 1, "columns": 4, "pattern": "independent"},
            font=dict(family="Arial"),
            height=250,
        )

        logger.info("create_kpi_summary lõpetatud")
        return fig

    except Exception as e:
        logger.error(f"create_kpi_summary viga: {e}")
        raise


def export_results(df: pd.DataFrame, output_dir: str = "output") -> dict:
    """
    Ekspordib andmed CSV failina ja diagrammid HTML failidena.
    Failinimed sisaldavad kuupäeva (nt results_20260312.csv).

    Parameetrid:
        df (pd.DataFrame): Eksporditavad andmed
        output_dir (str):  Väljundkaust (luuakse automaatselt)

    Tagastab:
        dict: Loodud failide teed
    """
    try:
        logger.info(f"export_results algab → {output_dir}/")

        # Loo output kaust, kui ei eksisteeri
        os.makedirs(output_dir, exist_ok=True)

        date_str = datetime.now().strftime("%Y%m%d")
        files_created = {}

        # CSV eksport
        csv_path = os.path.join(output_dir, f"results_{date_str}.csv")
        df.to_csv(csv_path, index=False)
        files_created["csv"] = csv_path
        logger.info(f"CSV salvestatud: {csv_path}")

        logger.info(f"export_results lõpetatud: {len(files_created)} faili loodud")
        return files_created

    except Exception as e:
        logger.error(f"export_results viga: {e}")
        raise


def export_charts(fig_weekly: go.Figure, fig_kpis: go.Figure,
                  output_dir: str = "output") -> dict:
    """
    Salvestab Plotly diagrammid HTML failidena.
    """
    try:
        os.makedirs(output_dir, exist_ok=True)
        date_str = datetime.now().strftime("%Y%m%d")
        files_created = {}

        weekly_path = os.path.join(output_dir, f"weekly_revenue_{date_str}.html")
        fig_weekly.write_html(weekly_path)
        files_created["weekly_chart"] = weekly_path
        logger.info(f"Diagramm salvestatud: {weekly_path}")

        kpi_path = os.path.join(output_dir, f"kpi_summary_{date_str}.html")
        fig_kpis.write_html(kpi_path)
        files_created["kpi_chart"] = kpi_path
        logger.info(f"KPI diagramm salvestatud: {kpi_path}")

        return files_created

    except Exception as e:
        logger.error(f"export_charts viga: {e}")
        raise


# Testimine
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO,
                        format="%(asctime)s - %(levelname)s - %(message)s")

    print("=== Roll C: Visualize + Export test ===")
    try:
        import sys
        sys.path.insert(0, ".")
        from transform import clean_data, calculate_weekly_aggregates, calculate_kpis

        df_raw = pd.read_csv("sales.csv")
        df_clean = clean_data(df_raw)
        weekly = calculate_weekly_aggregates(df_clean)
        kpis = calculate_kpis(df_clean)

        fig1 = create_weekly_chart(weekly)
        fig2 = create_kpi_summary(kpis)

        files = export_results(df_clean)
        charts = export_charts(fig1, fig2)

        print("Loodud failid:")
        for k, v in {**files, **charts}.items():
            print(f"  {k}: {v}")

    except Exception as e:
        print(f"Viga testimisel: {e}")
