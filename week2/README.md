# Nädal 2: SQL Andmete Puhastamine — UrbanStyle'i andmekvaliteedi audit

## Mida ma tegin
- Leidsin duplikaadid, NULL väärtused ja loogilised vead kõigis kolmes tabelis
- Viisin läbi ristvalideerimise tabelite vahel (sales ↔ customers ↔ products)
- Kirjutasin puhastamisskriptid test koopiatele (mitte production tabelitel)
- Osalesin meeskonna andmekvaliteedi raporti koostamisel (Roll A: Sales Data Cleaner)

## Peamised õpid
- `CREATE TABLE ... AS SELECT *` — test koopia loomine enne puhastamist
- `GROUP BY ... HAVING COUNT(*) > 1` — duplikaatide tuvastamine
- `COUNT(*) FILTER (WHERE ...)` — NULL väärtuste loendamine korraga
- `LEFT JOIN ... WHERE b.id IS NULL` — orbide leidmine tabelite vahel
- `NULLIF()` — nulliga jagamise vältimine
- NULL ei tähenda alati viga — kontekst määrab (külalisostud)

## Olulisemad leiud
- **5 116 duplikaatrida** sales tabelis — moonutavad kõiki müüginäitajaid
- **664 hinna ebakõla** — müügihind ei klapi retail_price × quantity-ga
- **54 linna nimekuju varianti** customers tabelis — geograafiline analüüs vigane
- **592 vaimklienti** (~18.8%) — registreeritud, aga pole kunagi ostnud
- products on kolmest tabelist kõige puhtam — 0 kriitilist probleemi

## Failid
### individual/
- `week2_roll_a_sales_cleaning.sql` — müügiandmete puhastamine
- `week2_roll_b_customers_cleaning.sql` — kliendiandmete puhastamine
- `week2_roll_c_products_cleaning.sql` — tooteandmete puhastamine
- `week2_roll_d_cross_validation.sql` — ristvalideerimine tabelite vahel

### team/
- `week2_data_quality_report.md` — meeskonna koondraport prioriteetidega
