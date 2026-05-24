"""
UrbanStyle | Week 8 | Roll A: API Query
Autor: Vladimir G
Kirjeldus: Supabase API päringud — müügi-, kliendi- ja tooteandmed
"""

import os
import time
import pandas as pd
from dotenv import load_dotenv

# Lae .env fail (MITTE KUNAGI kirjuta API key otse koodi!)
load_dotenv()

try:
    from supabase import create_client, Client
    SUPABASE_URL = os.getenv("SUPABASE_URL")
    SUPABASE_KEY = os.getenv("SUPABASE_KEY")

    if not SUPABASE_URL or not SUPABASE_KEY:
        raise ValueError("SUPABASE_URL või SUPABASE_KEY puudub .env failist!")

    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
except Exception as e:
    print(f"[HOIATUS] Supabase ühendus ebaõnnestus: {e}")
    print("[INFO] Varuplaanina kasuta CSV faile.")
    supabase = None


def _fetch_with_pagination(table: str, filters: dict = None,
                            page_size: int = 1000) -> list:
    """
    Abifunktsioon: pärib kõik read Supabase tabelist pagination abil.
    Supabase tagastab max 1000 rida korraga — suurte tabelite jaoks vajalik.

    Edasijõudnute tase: exponential backoff retry loogika vigade korral.
    """
    if supabase is None:
        return []

    all_data = []
    offset = 0
    max_retries = 3

    while True:
        retries = 0
        while retries < max_retries:
            try:
                query = supabase.table(table).select("*").range(
                    offset, offset + page_size - 1
                )
                if filters:
                    for key, value in filters.items():
                        if key.startswith("gte_"):
                            query = query.gte(key[4:], value)
                        elif key.startswith("lte_"):
                            query = query.lte(key[4:], value)

                response = query.execute()
                batch = response.data

                if not batch:
                    return all_data

                all_data.extend(batch)

                if len(batch) < page_size:
                    return all_data

                offset += page_size
                break

            except Exception as e:
                retries += 1
                wait = 2 ** retries  # exponential backoff: 2, 4, 8 sekundit
                print(f"[HOIATUS] Päring ebaõnnestus (katse {retries}/{max_retries}): {e}")
                if retries < max_retries:
                    print(f"[INFO] Ootan {wait}s enne uut katset...")
                    time.sleep(wait)
                else:
                    print(f"[VIGA] Maksimaalne katsete arv ({max_retries}) ületatud.")
                    return all_data


def fetch_sales(start_date: str = None, end_date: str = None) -> pd.DataFrame:
    """
    Pärib müügiandmed Supabase'ist.

    Parameetrid:
        start_date (str): Alguskuupäev formaadis 'YYYY-MM-DD' (valikuline)
        end_date   (str): Lõppkuupäev formaadis 'YYYY-MM-DD' (valikuline)

    Tagastab:
        pd.DataFrame: Müügiandmed veergudega sale_id, sale_date, total_price, jne.
    """
    try:
        # Varuplaanina: CSV failist
        if supabase is None:
            df = pd.read_csv("sales.csv")
            if start_date:
                df = df[df["sale_date"] >= start_date]
            if end_date:
                df = df[df["sale_date"] <= end_date]
            print(f"[INFO] fetch_sales (CSV): {df.shape[0]} rida laetud")
            return df

        filters = {}
        if start_date:
            filters["gte_sale_date"] = start_date
        if end_date:
            filters["lte_sale_date"] = end_date

        data = _fetch_with_pagination("sales", filters)
        df = pd.DataFrame(data)
        print(f"[INFO] fetch_sales (API): {df.shape[0]} rida laetud")
        return df

    except Exception as e:
        print(f"[VIGA] fetch_sales ebaõnnestus: {e}")
        return pd.DataFrame()


def fetch_customers() -> pd.DataFrame:
    """
    Pärib kliendiandmed Supabase'ist.

    Tagastab:
        pd.DataFrame: Kliendiandmed veergudega customer_id, email, city, jne.
    """
    try:
        if supabase is None:
            df = pd.read_csv("customers.csv")
            print(f"[INFO] fetch_customers (CSV): {df.shape[0]} rida laetud")
            return df

        data = _fetch_with_pagination("customers")
        df = pd.DataFrame(data)
        print(f"[INFO] fetch_customers (API): {df.shape[0]} rida laetud")
        return df

    except Exception as e:
        print(f"[VIGA] fetch_customers ebaõnnestus: {e}")
        return pd.DataFrame()


def fetch_products() -> pd.DataFrame:
    """
    Pärib tooteandmed Supabase'ist.

    Tagastab:
        pd.DataFrame: Tooteandmed veergudega product_id, product_name,
                      category, retail_price, jne.
    """
    try:
        if supabase is None:
            df = pd.read_csv("products.csv")
            print(f"[INFO] fetch_products (CSV): {df.shape[0]} rida laetud")
            return df

        data = _fetch_with_pagination("products")
        df = pd.DataFrame(data)
        print(f"[INFO] fetch_products (API): {df.shape[0]} rida laetud")
        return df

    except Exception as e:
        print(f"[VIGA] fetch_products ebaõnnestus: {e}")
        return pd.DataFrame()


# Testimine
if __name__ == "__main__":
    print("=== Roll A: Data Fetcher test ===")
    df_sales = fetch_sales(start_date="2024-01-01", end_date="2024-12-31")
    print(f"Sales shape: {df_sales.shape}")
    if not df_sales.empty:
        print(df_sales.head(3))

    df_customers = fetch_customers()
    print(f"\nCustomers shape: {df_customers.shape}")

    df_products = fetch_products()
    print(f"\nProducts shape: {df_products.shape}")
