# Nädal 4: SQL Agregatsioon — GROUP BY, CTE ja Window Functions

## Mida ma tegin
- Koostasin müügistatistika kuu- ja kategooriapõhiselt DATE_TRUNC ja GROUP BY abil
- Segmenteerisin kliendid VIP/Regular/Uus CASE WHEN ja CTE abil
- Analüüsisin turunduskanalite ROI-d, ühendades sales, customers ja web_logs
- Kasutasin window functions: LAG(), RANK(), ROW_NUMBER()
- Osalesin meeskonna koondraportis (Roll A: müügi kuutrendid)

## Peamised õpid
- `DATE_TRUNC('month', ...)` — kuupõhine grupeerimine
- `WITH ... AS (...)` — CTE mitme sammuga päringu struktueerimiseks
- `LAG() OVER (ORDER BY ...)` — eelmise kuu võrdlus
- `RANK() OVER (PARTITION BY ... ORDER BY ...)` — järjestus grupi sees
- `HAVING` — agregeeritud tulemuste filtreerimine (mitte WHERE)
- `NULLIF()` — nulliga jagamise vältimine efektiivsuse arvutamisel
- `LOWER(TRIM())` — andmekvaliteedi normaliseerimine päringus

## Olulisemad leiud
- **Detsember** oli 2024 parim kuu (260 334 €, +61.5% novembrist)
- **52 VIP klienti** (2%) genereerivad ~11% kogukäibest
- **Google Ads** on turunduse parim ROI (1 773 € per klient)
- **40 toodet** on kriitilises laoseisus — kohene tellimus vajalik
- **TikTok** on madalaima efektiivsusega kanal (1 307 €/klient)

## Failid
### individual/
- `week4_roll_a_sales_aggregation.sql` — kuutrendid, kategooriad, CTE + LAG
- `week4_roll_b_customer_segmentation.sql` — VIP/Regular/Uus, RANK per linn
- `week4_roll_c_inventory_statistics.sql` — inventuur, ROW_NUMBER, TOP 3 per kategooria
- `week4_roll_d_marketing_roi.sql` — turunduskanalite ROI, web_logs JOIN, CTE

### team/
- `week4_aggregation_report.md` — meeskonna koondraport soovitustega

## AI kasutamine
Kasutasin Claude'i web_logs source veeru normaliseerimise lahenduse leidmiseks — andmebaasis esinesid sama kanali erinevad kirjaviisid ('google_organic', 'Google Organic', 'google organic'). AI soovitas LOWER(TRIM(source)) lahendust otse GROUP BY klauslis, mis välistas vajaduse eraldi puhastuspäringu järele.
