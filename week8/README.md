# Nädal 8: Python API Pipeline — Automatiseerimine

## Minu roll: D — Automation Script (Pipeline orkestratsioon)

Ühendasin meeskonna moodulid (Roll A, B, C) üheks töötavaks pipeline'iks `pipeline.py`-s. Lisasin failipõhise logimise (`logs/pipeline_YYYYMMDD.log`), etappide ajamõõtmise, veakäsitluse iga etapi kohta eraldi ja `__main__` bloki ühe käsuga käivitamiseks.

## Meeskonna pipeline kokkuvõte

| Roll | Moodul | Funktsioonid |
|------|--------|-------------|
| A | `data_fetcher.py` | fetch_sales(), fetch_customers(), fetch_products() |
| B | `transform.py` | clean_data(), calculate_weekly_aggregates(), calculate_kpis(), merge_datasets() |
| C | `visualize_export.py` | create_weekly_chart(), create_kpi_summary(), export_results(), export_charts() |
| D | `pipeline.py` | run_pipeline() — orkestreeib kõik etapid |

## Pipeline väljund

```
[1/4] EXTRACT    → sales=10118, customers=3150, products=362
[2/4] TRANSFORM  → 8950 puhast rida, 2540 unikaalset klienti
[3/4] VISUALIZE  → 2 Plotly diagrammi
[4/4] EXPORT     → output/results_YYYYMMDD.csv
                   output/weekly_revenue_YYYYMMDD.html
                   output/kpi_summary_YYYYMMDD.html
```

## Turvanõuded
- `.env` on `.gitignore`'is — API võtmeid ei commit'ita ❌
- `.env.example` on lisatud — näitab struktuuri ✅
- API võtmed loetakse `os.getenv()` abil ✅

## Failid
### individual/
- `pipeline.py` — Roll D: terviklik pipeline orkestratsioon
- `.env.example` — keskkonna muutujate mall

### team/
- `transform.py` — Roll B: andmete töötlemine
- `visualize_export.py` — Roll C: visualiseerimine ja eksport
- `pipeline.py` — Roll D: terviklik pipeline
- `week8_pipeline_demo.md` — pipeline arhitektuur ja käivitusjuhend

## AI kasutamine
Kasutasin Claude'i pipeline'i veakäsitluse struktureerimiseks — kuidas korraldada try/except nii, et iga etapp (Extract, Transform, Visualize, Export) ebaõnnestub iseseisvalt ilma kogu pipeline'i krahhimata. AI soovitas ka failipõhise logimise mustri `logging.FileHandler` abil, mis salvestab iga käivituse eraldi logi faili.
