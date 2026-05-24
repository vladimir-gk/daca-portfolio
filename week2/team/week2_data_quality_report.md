# Week 2 | Meeskonna andmekvaliteedi raport

## Puhastamise kokkuvõte

| Tabel | Ridu | Peamised probleemid | Kriitilisus |
|-------|------|---------------------|-------------|
| sales | 15 234 | 5 116 duplikaati, 5 tuleviku kuupäeva | 🔴 Kõrge |
| customers | 3 150 | 128 duplikaatset e-maili, 54 linna nimekuju varianti, 380 NULL e-maili | 🟡 Keskmine |
| products | 362 | 12 duplikaatset tootenime | 🟢 Madal |

## Rollide kokkuvõte

**Roll A — Müügiandmete puhastamine (sales)**
- 5 116 duplikaatrida — moonutavad kõiki müüginäitajaid
- 1 487 NULL customer_id — külalisostud, kehtiv äriloogika (mitte viga)
- 5 tuleviku kuupäeva — andmesisestuse vead
- NULL sale_date ja total_price: 0 — kriitilised väljad on täidetud

**Roll B — Kliendiandmete puhastamine (customers)**
- 128 duplikaatset e-maili — topeltregistreerimised
- 54 erinevat nimekuju 12 linnale ('Tallinn', 'tallinn', 'TALLINN', ' Tallinn')
- 380 klienti (~12.1%) ilma e-mailita — turunduse probleem
- Eesnimed ja perenimed: kõik olemas

**Roll C — Tooteandmete puhastamine (products)**
- 12 duplikaatset tootenime — vajalik manuaalne kontroll (variant vs duplikaat?)
- Hinnad: negatiivseid ega äärmuslikke väärtusi pole
- Kategooriad: 5 ühtset väärtust, snake_case formaat
- Üldiselt kõige puhtam tabel

**Roll D — Ristvalideerimine (sales ↔ customers ↔ products)**
- 0 orb customer_id — viiteintegriteeet korras
- 0 orb product_id — viiteintegriteeet korras
- 664 hinna ebakõla (müügihind ≠ retail_price × quantity)
- 592 vaimklienti — registreeritud, aga pole kunagi ostnud (~18.8%)
- 12 vaimtoodet — kataloogis, aga müümata

## Andmekvaliteedi probleemid prioriteedi järgi

| Prioriteet | Probleem | Tabel | Mõju |
|------------|----------|-------|------|
| 🔴 1 | 5 116 duplikaatrida | sales | Kõik müügiaruanded on valed |
| 🔴 2 | 664 hinna ebakõla | sales + products | Tulude ja marginaali analüüs vigane |
| 🟡 3 | 54 linna nimekuju varianti | customers | Geograafiline analüüs moonutatud |
| 🟡 4 | 592 vaimklienti | customers | Turunduse segmenteerimine vigane |
| 🟢 5 | 128 duplikaatset e-maili | customers | Kommunikatsioon topelt |
| 🟢 6 | 12 vaimtoodet | products | Kataloog ei vasta tegelikkusele |
