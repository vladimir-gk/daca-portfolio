# Nädal 6: Power BI Andmelood — Kaupluste visualisatsioon ja narratiiv

## Mida ma tegin
- Lõin Tallinna kaupluse interaktiivse dashboardi koos andmelooga (Roll A)
- Rakendasin Knaflic Ch 5-6 storytelling põhimõtteid: annotatsioonid, viitejooned, juhtide kokkuvõte
- Filtreerisin andmed kaupluse tasemele (store_location = 'Tallinn')
- Osalesin meeskonna kaupluste koondülevaate koostamisel

## Peamised õpid
- Andmelugu struktuur: ülesseade → andmed → konflikt → soovitus
- Annotatsioonid selgitavad MIKS number on oluline, mitte ainult mis see on
- Viitejoon (keskmine kuukäive) annab numbrile konteksti
- "Ja mis siis?" test — iga järeldus peab vastama sellele küsimusele
- Kliendisegmentide visualiseerimine: uus vs korduv vs lojaalne

## Olulisemad leiud — Tallinna dashboard (2023–2024)
- **Kogukäive: 1.02M €** | 3 546 tellimust | AOV 287 €
- **YoY kasv +10.75%** (2023→2024) — stabiilne kasvutempo
- **Detsember 2024 rekordkuu: 64K €** (+42% vs detsember 2023)
- **Keskmine kuukäive ~40K €** — viitejoon diagrammil
- **Kliendisegmendid:** 950 uut klienti | 673 korduvat | 96 lojaalset
- **TOP 5 tooted** on võrdselt tugevad — vahe vaid €1.3K, risk hästi hajutatud

## Juhtide kokkuvõte (dashboard ülaosas)
- Tallinna käive kasvas 2024. aastal +10.7% — kasvutempo kinnitab juhtpositsiooni
- Detsember 2024 oli rekordkuu €64K — +42% vs detsember 2023. Korda kampaaniat!
- TOP 5 tooted on stabiilsed — vahe vaid €1.3K, risk on hästi hajutatud
- Suvi (juuni–august) on igal aastal tugevaim periood — suvekampaaniad töötavad
- 950 uut klienti 2023–2024 — uute klientide ligimeelitamine töötab hästi

## Failid
### individual/
- `week6_roll_a_tallinn_dashboard.pbix` — Tallinna kaupluse dashboard
- `week6_dashboard_screenshot.png` — ekraanipilt valmis dashboardist
- `week6_sql_queries.sql` — kõigi rollide andmepäringud Power BI jaoks

### team/
- `week6_store_stories_report.md` — kõigi kaupluste lood ja investori soovitused

## AI kasutamine
Kasutasin Claude'i kaupluste andmelugude struktureerimiseks (ülesseade → konflikt → soovitus) ja SQL päringute kirjutamiseks hooajalise analüüsi jaoks. AI aitas tuvastada e-poe +35.4% YoY kasvu ärilist tähendust võrreldes füüsiliste kauplustega ning kontrollis dashboard'i numbrite vastavust andmeallikaga.

## Meeskonna panus
Meie meeskond analüüsis UrbanStyle'i 4 asukohta. Minu panus: Tallinna dashboard + narratiiv.
Meeskonna koondvaade: [week6_team_combined_view.md](team/week6_team_combined_view.md)
