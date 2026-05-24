# Week 8 | Meeskonna Pipeline Demo

## Arhitektuur

```
python pipeline.py
       │
       ├── [1/4] EXTRACT   → data_fetcher.py   (Roll A)
       │         fetch_sales(), fetch_customers(), fetch_products()
       │
       ├── [2/4] TRANSFORM → transform.py       (Roll B)
       │         clean_data(), merge_datasets()
       │         calculate_weekly_aggregates(), calculate_kpis()
       │
       ├── [3/4] VISUALIZE → visualize_export.py (Roll C)
       │         create_weekly_chart(), create_kpi_summary()
       │
       └── [4/4] EXPORT    → visualize_export.py (Roll C)
                 export_results(), export_charts()
                 → output/results_YYYYMMDD.csv
                 → output/weekly_revenue_YYYYMMDD.html
                 → output/kpi_summary_YYYYMMDD.html
                 → logs/pipeline_YYYYMMDD.log
```

## Käivitamine

```bash
# 1. Installi sõltuvused
pip install pandas plotly python-dotenv supabase

# 2. Loo .env fail (varuplaanina toimib ka CSV failidega)
cp .env.example .env
# Täida SUPABASE_URL ja SUPABASE_KEY

# 3. Käivita pipeline
python pipeline.py
```

## Integratsioonitesti tulemused

| Etapp | Tulemus | Märkus |
|-------|---------|--------|
| Extract | ✅ | CSV varuplaaniga töötab ilma API-ta |
| Transform | ✅ | 15 234 → 8 950 puhast rida |
| Visualize | ✅ | 2 Plotly diagrammi loodud |
| Export | ✅ | CSV + 2 HTML faili output/ kausta |

## Pipeline KPI väljund (2023–2025)

```
Pipeline ÕNNESTUS
Kogutulu:           2 676 231.00 EUR
Unikaalseid kliente: 2 540
Keskmine tellimus:  299.02 EUR
```

## Turvanõuded

- `.env` fail on `.gitignore`'is — API võtmeid ei commit'ita
- `.env.example` näitab struktuuri ilma tegelike väärtusteta
- API võtmed loetakse `os.getenv()` abil, mitte hardcoded

