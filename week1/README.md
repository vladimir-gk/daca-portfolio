# Nädal 1: SQL Basics — UrbanStyle'i müügiandmete uurimine

## Mida ma tegin
- Uurisin `sales` tabelit SQL päringutega: maht, veerud, kanalid, asukohad
- Leidsin andmekvaliteedi probleemid: negatiivsed hinnad, puuduvad kliendid, segased kuupäevavormingud
- Osalesin meeskonna andmemaastiku koostamisel (Roll A: Sales Data Explorer)

## Peamised õpid
- `COUNT(*)` vs `COUNT(veerg)` — erinevus NULL väärtuste loendamisel
- `COALESCE()` — NULL väärtuste asendamine loetava tekstiga
- `DISTINCT` — unikaalsete väärtuste leidmine
- `ORDER BY`, `WHERE`, `AND` — filtreerimine ja sorteerimine
- Andmekvaliteedi kontroll on analüüsi esimene samm, mitte viimane

## Olulisemad leiud
- Tabelis on **15 234 rida** ja **11 veergu**
- **305 negatiivset** `total_price` väärtust — tõenäoliselt tagastused, kuid eraldi veergu pole
- **1 487 rida** (~9.8%) ilma `customer_id`-ta
- **457 rida** kasutab kuupäevavormingut `DD/MM/YYYY` — andmepuhastus vajalik
- Müügikanalid: ainult 2 — `pood` ja `online`
- Suurim tehing: **2 170.40 €** | Väikseim: **−1 405.32 €**

## Failid
- `week1_sales_exploration.sql` — kõik SQL päringud koos kommentaaridega (11 päringut)
- `week1results_screenshot.png` — tulemuste ekraanitõmmis Supabase'ist

