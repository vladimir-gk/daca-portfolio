# Nädal 3: SQL JOIN-analüüs — UrbanStyle'i andmete ühendamine

## Mida ma tegin
- Ühendasin `sales`, `customers`, `products` ja `inventory` tabeleid INNER JOIN ja LEFT JOIN päringutega
- Leidsin TOP kliendid, kadunud kliendid, müümata tooted ja kanalite efektiivsuse
- Kirjutasin ärilised soovitused Annale ja Toomasele numbrilise põhjendusega
- Osalesin meeskonna JOIN-analüüsi koondülevaate koostamisel (Roll A)

## Peamised õpid
- `INNER JOIN` — tagastab ainult read, kus mõlemas tabelis on vastav kirje
- `LEFT JOIN` + `WHERE b.id IS NULL` — leiab read, millel pole vastet (kadunud kliendid, müümata tooted)
- `GROUP BY` + `SUM/COUNT` koos JOIN-iga — agregeeritud analüüs
- `HAVING SUM(...) > (SELECT AVG(...))` — alamjärjepäring filtreerimiseks
- `NULLIF()` — nulliga jagamise vältimine efektiivsuse arvutamisel
- 3 tabeli JOIN: `FROM a INNER JOIN b ON ... INNER JOIN c ON ...`

## Olulisemad leiud
- **592 klienti** (18.8%) pole kunagi ostnud — kontsentreerunud 2024 Q4–2025 Q1
- **34%** klientidest kulutavad üle keskmise (1 540 €) — VIP segment
- **Pood** on per-klient efektiivsem: 1 245 € vs online 882 € (+41%)
- **12 toodet** pole kunagi müüdud — kataloogist eemaldamise kandidaadid
- **231 toodet** kriitilises laoseisus — tellimist vajavad

## Failid
### individual/
- `week3_roll_a_myyk_kliendid_joins.sql` — INNER JOIN müük + kliendid, TOP analüüs
- `week3_roll_b_kadunud_kliendid_joins.sql` — LEFT JOIN kadunud klientide tuvastamine
- `week3_roll_c_tooted_inventuur_joins.sql` — LEFT JOIN tooted + inventuur, 3 tabelit
- `week3_roll_d_muugikanalid_joins.sql` — 3 tabeli JOIN kanalite efektiivsuse analüüs

### team/
- `week3_join_analysis_report.md` — meeskonna koondülevaade soovitustega
