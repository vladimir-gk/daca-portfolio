# Week 7 | Meeskonna RFM analüüsi koondraport

## Pipeline kokkuvõte

| Roll | Etapp | Peamine tulemus |
|------|-------|----------------|
| A | Data Loading | 10 118 rida laetud, merge tehtud customer_id põhjal |
| B | Data Cleaning | 8 950 puhast rida, 2 540 unikaalset klienti |
| C | RFM Analysis | 5 segmenti, VIP = 39.4% käibest |
| D | Visualization | 3 Plotly diagrammi + soovitused Markole |

## Puhastusraport (Roll B)

| Probleem | Eemaldatud | Põhjus |
|----------|-----------|--------|
| Duplikaadid (sale_id) | 5 116 rida | Topeltkanded andmebaasis |
| NULL customer_id | 988 rida | Külalisostud — RFM jaoks kasutamatu |
| Negatiivsed hinnad | 180 rida | Tagastused — moonutavad Monetary väärtust |
| Tuleviku kuupäevad | ~5 rida | Andmesisestuse vead |
| **Lõplik** | **8 950 rida** | **Valmis RFM analüüsiks** |

## RFM segmentide kokkuvõte (Roll C)

| Segment | Kliente | Osakaal | Kogukäive | Käive % | Tegevus |
|---------|---------|---------|-----------|---------|---------|
| VIP Champions | 388 | 15.3% | 1 053 783 € | 39.4% | VIP programm, early access |
| Loyal | 674 | 26.5% | 820 167 € | 30.6% | Lojaalsusprogramm, preemiad |
| Potential | 705 | 27.8% | 513 489 € | 19.2% | Cross-sell kampaaniad |
| At Risk | 612 | 24.1% | 259 032 € | 9.7% | Win-back kampaania |
| Lost | 161 | 6.3% | 30 379 € | 1.1% | Viimane katse, suur soodustus |

## Soovitused Markole

**Peamine järeldus:** 388 VIP klienti (15.3%) genereerivad 39.4% kogu käibest. See on Pareto printsiip praktikas — UrbanStyle'i käekäik sõltub kriitiliselt väikesest grupist.

1. **VIP programm** — eksklusiivne kohtlemine 388 kliendile (early access, personaliseeritud sooduskoodid)
2. **Win-back kampaania** — 612 At Risk klienti, isegi 20% konversioon = ~50 000 EUR lisatulu
3. **Potential → Loyal** — 705 klienti on kasvatamise kandidaadid (odavam kui uute hankimine)
