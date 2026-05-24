"""
UrbanStyle | Week 8 | Roll B: Data Processing
Autor: Vladimir G
Kirjeldus: Andmete puhastamine, nädalased koondnäitajad, KPI-d, merge
"""

import logging
import pandas as pd

logger = logging.getLogger(__name__)


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Puhastab DataFrame'i:
    - Eemaldab duplikaadid (sale_id alusel)
    - Käsitleb NULL väärtused kriitilistes veergudes
    - Teisendab kuupäevad datetime formaati (mixed formats toetatud)
    - Eemaldab negatiivsed ja null hinnad (tagastused)
    - Eemaldab tuleviku kuupäevad

    Parameetrid:
        df (pd.DataFrame): Toorandmed

    Tagastab:
        pd.DataFrame: Puhastatud andmed
    """
    try:
        logger.info(f"clean_data algab: {df.shape[0]} rida")
        initial_count = df.shape[0]

        # Valideeri sisend
        required_cols = ["sale_id", "sale_date", "total_price", "customer_id"]
        missing = [c for c in required_cols if c not in df.columns]
        if missing:
            raise ValueError(f"Puuduvad veerud: {missing}")

        # 1. Duplikaadid
        before = df.shape[0]
        df = df.drop_duplicates(subset="sale_id")
        logger.info(f"Duplikaadid eemaldatud: {before - df.shape[0]} rida")

        # 2. NULL väärtused kriitilistes veergudes
        before = df.shape[0]
        df = df.dropna(subset=["customer_id", "sale_date", "total_price"])
        logger.info(f"NULL read eemaldatud: {before - df.shape[0]} rida")

        # 3. Kuupäevad — mixed format (YYYY-MM-DD ja DD/MM/YYYY)
        def parse_date(d):
            try:
                if "/" in str(d):
                    return pd.to_datetime(d, format="%d/%m/%Y")
                return pd.to_datetime(d, format="%Y-%m-%d")
            except Exception:
                return pd.NaT

        df["sale_date"] = df["sale_date"].apply(parse_date)
        before = df.shape[0]
        df = df.dropna(subset=["sale_date"])
        logger.info(f"Vigased kuupäevad eemaldatud: {before - df.shape[0]} rida")

        # 4. Negatiivsed hinnad (tagastused)
        before = df.shape[0]
        df = df[df["total_price"] > 0]
        logger.info(f"Negatiivsed hinnad eemaldatud: {before - df.shape[0]} rida")

        # 5. Tuleviku kuupäevad
        reference_date = pd.Timestamp("2025-02-28")
        before = df.shape[0]
        df = df[df["sale_date"] <= reference_date]
        logger.info(f"Tuleviku kuupäevad eemaldatud: {before - df.shape[0]} rida")

        logger.info(
            f"clean_data lõpetatud: {initial_count} → {df.shape[0]} rida "
            f"({initial_count - df.shape[0]} eemaldatud)"
        )
        return df.reset_index(drop=True)

    except Exception as e:
        logger.error(f"clean_data viga: {e}")
        raise


def calculate_weekly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    """
    Arvutab nädalased koondnäitajad.

    Tagastab DataFrame veergudega:
        week, revenue, order_count, avg_order_value
    """
    try:
        logger.info("calculate_weekly_aggregates algab")

        if "sale_date" not in df.columns:
            raise ValueError("Veerg 'sale_date' puudub. Käivita esmalt clean_data().")

        df = df.copy()
        df["sale_date"] = pd.to_datetime(df["sale_date"])

        weekly = (
            df.set_index("sale_date")
            .resample("W")["total_price"]
            .agg(
                revenue="sum",
                order_count="count",
                avg_order_value="mean"
            )
            .round(2)
            .reset_index()
            .rename(columns={"sale_date": "week"})
        )

        logger.info(f"calculate_weekly_aggregates lõpetatud: {weekly.shape[0]} nädalat")
        return weekly

    except Exception as e:
        logger.error(f"calculate_weekly_aggregates viga: {e}")
        raise


def calculate_kpis(df: pd.DataFrame) -> dict:
    """
    Arvutab põhilised KPI-d.

    Tagastab:
        dict: {
            total_revenue, unique_customers, avg_order_value,
            total_orders, date_range_start, date_range_end
        }
    """
    try:
        logger.info("calculate_kpis algab")

        kpis = {
            "total_revenue": round(df["total_price"].sum(), 2),
            "unique_customers": int(df["customer_id"].nunique()),
            "avg_order_value": round(df["total_price"].mean(), 2),
            "total_orders": int(df.shape[0]),
            "date_range_start": str(df["sale_date"].min().date()),
            "date_range_end": str(df["sale_date"].max().date()),
        }

        logger.info(
            f"KPI-d arvutatud: käive={kpis['total_revenue']:,.0f} EUR, "
            f"kliente={kpis['unique_customers']}, AOV={kpis['avg_order_value']:.2f}"
        )
        return kpis

    except Exception as e:
        logger.error(f"calculate_kpis viga: {e}")
        raise


def merge_datasets(df_sales: pd.DataFrame,
                   df_customers: pd.DataFrame) -> pd.DataFrame:
    """
    Liidab müügi- ja kliendiandmed customer_id järgi (LEFT JOIN).

    Tagastab:
        pd.DataFrame: Liidatud andmed
    """
    try:
        logger.info("merge_datasets algab")

        cols = ["customer_id", "email", "first_name", "last_name", "city"]
        cols_available = [c for c in cols if c in df_customers.columns]

        df_merged = pd.merge(
            df_sales,
            df_customers[cols_available],
            on="customer_id",
            how="left"
        )

        logger.info(
            f"merge_datasets lõpetatud: {df_merged.shape[0]} rida, "
            f"{df_merged.shape[1]} veergu"
        )
        return df_merged

    except Exception as e:
        logger.error(f"merge_datasets viga: {e}")
        raise


# Testimine
if __name__ == "__main__":
    import sys
    logging.basicConfig(level=logging.INFO,
                        format="%(asctime)s - %(levelname)s - %(message)s")

    print("=== Roll B: Transform test ===")
    try:
        df_raw = pd.read_csv("sales.csv")
        df_clean = clean_data(df_raw)
        print(f"Puhastatud: {df_clean.shape}")

        weekly = calculate_weekly_aggregates(df_clean)
        print(f"Nädalased koondandmed: {weekly.shape}")
        print(weekly.tail(3))

        kpis = calculate_kpis(df_clean)
        print(f"\nKPI-d: {kpis}")

    except Exception as e:
        print(f"Viga testimisel: {e}")
        sys.exit(1)
