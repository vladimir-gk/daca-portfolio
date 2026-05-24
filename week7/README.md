# Nädal 7: Python Pandas — RFM kliendisegmenteerimine

## Minu roll: A — Data Loading (Andmete laadimine ja liitmine)

Laadisin `sales` ja `customers` CSV failid pandas DataFrame'idesse ning liitsin need `customer_id` põhjal LEFT JOIN meetodil. Kontrollisin andmete struktuuri (`shape`, `dtypes`, `head()`).

## Peamised leiud
- `df_sales`: 15 234 rida, 11 veergu — laetud edukalt
- `df_customers`: 3 150 rida, 9 veergu — laetud edukalt
- Liidatud DataFrame: 10 118 rida pärast duplikaatide eemaldamist
- LEFT JOIN säilitab kõik müügid, ka külalisostud (NULL customer_id)

## Pipeline kokkuvõte (meeskond)

| Roll | Etapp | Tulemus |
|------|-------|---------|
| A | Data Loading | 10 118 rida laetud, merge tehtud |
| B | Data Cleaning | 8 950 puhast rida, 2 540 unikaalset klienti |
| C | RFM Analysis | 5 segmenti, VIP = 39.4% käibest |
| D | Visualization | 3 Plotly diagrammi + soovitused Markole |

## RFM segmentide kokkuvõte

| Segment | Kliente | Käive | Käive % |
|---------|---------|-------|---------|
| VIP Champions | 388 | 1 053 783 € | 39.4% |
| Loyal | 674 | 820 167 € | 30.6% |
| Potential | 705 | 513 489 € | 19.2% |
| At Risk | 612 | 259 032 € | 9.7% |
| Lost | 161 | 30 379 € | 1.1% |

## Failid
### individual/
- `week7_rfm_roll_a.ipynb` — Roll A: andmete laadimine ja liitmine

### team/
- `week7_rfm_complete.ipynb` — meeskonna terviklik notebook (Rollid A–D)
- `week7_rfm_team_report.md` — koondraport soovitustega Markole

## AI kasutamine
Kasutasin Claude'i `pd.merge()` LEFT JOIN loogika selgitamiseks — eriti miks külalisostud (NULL customer_id) säilivad LEFT JOIN puhul, aga kaoksid INNER JOIN korral. AI selgitas erinevuse praktilistel andmenäidetel.
