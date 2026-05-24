# Week 1 | Meeskonna andmemaastik (Data Landscape)

## UrbanStyle'i andmebaasi ülevaade

| Tabel | Ridu | Veerge | Peamine leid |
|-------|------|--------|--------------|
| sales | 15 234 | 11 | 305 negatiivset hinda, 457 segast kuupäeva |
| customers | 3 150 | 9 | 130 duplikaatset e-maili, linna kirjaviisi probleemid |
| products | 362 | 9 | 5 kategooriat, hinnavahemik 13.53–434.08 € |

## Rollide kokkuvõte

**Roll A — Müügiandmed (sales)**
- 15 234 tehingut ajavahemikus 2020–2025
- 305 negatiivset `total_price` — tõenäoliselt tagastused, kuid eraldi veergu pole
- 1 487 tehingut (~9.8%) ilma `customer_id`-ta
- 457 rida kasutab kuupäevavormingut `DD/MM/YYYY` — puhastus vajalik

**Roll B — Kliendiandmed (customers)**
- 3 150 klienti, registreerimised alates 2020-01-02
- 380 kliendil (~12.1%) puudub e-mail
- 130 duplikaatset e-maili — võimalikud topeltregistreerimised
- Linna väli on räpane: 'Tallinn', 'tallinn', 'TALLINN', ' Tallinn' — kõik erinevad väärtused

**Roll C — Tooteandmed (products)**
- 362 toodet 5 kategoorias
- Kalleim toode: 434.08 € (jalanõusid) | Odavaim: 13.53 € (aksessuaarid)
- ~28% toodetest on ökomärgistusega (`eco_certified = true`)
- Tabelis puudub veerg `price` — tegelik veerg on `retail_price`

**Roll D — Müügikanalid ja asukohad (sales)**
- 2 müügikanalit: `pood` (65.8%) ja `online` (34.2%)
- 3 kauplust: Tallinn (56.9%), Tartu (27.0%), Pärnu (16.1%)
- 3 makseviisi praktiliselt võrdses jaotuses: kaart (33.7%), sularaha (33.5%), järelmaks (32.8%)
- 5 204 tehingut ilma `store_location`-ita — kõik online-müügid

## Andmekvaliteedi probleemid (kokkuvõte)

| Probleem | Tabel | Mõju |
|----------|-------|------|
| Segased kuupäevavormingud (DD/MM/YYYY) | sales | Ajaanalüüs vigane |
| Negatiivsed `total_price` väärtused | sales | Tagastused segamini müükidega |
| Linna kirjaviisi ebajärjepidevus | customers | Geograafiline analüüs moonutatud |
| Duplikaatsed e-mailid | customers | Klientide arv ülehinnatud |
| `eco_certified` NULL väärtused | products | 18 toodet klassifitseerimata |
