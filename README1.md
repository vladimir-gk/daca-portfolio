# Nädal 5: Power BI Dashboard — UrbanStyle OÜ Investori Ülevaade

## Ärikontekst

UrbanStyle OÜ on Eesti rõivakauplus, millel on 3 füüsilist kauplust (Tallinn, Tartu, Pärnu) ja kasvav e-pood. Juhtkond vajas **ühte dashboardi**, mis vastab kolmele küsimusele:

- **Kristi (CEO):** Kas ettevõte kasvab? Milline on trend?
- **Anna (turundus):** Milline müügikanal toob rohkem kliente ja tulu?
- **Liis (operatsioonid):** Kus on müük geograafiliselt ja milline on laoseis?

Lahendus: üks Power BI dashboard, mis mahub ühele ekraanile ja annab vastused 10 sekundiga.

---

## 📊 Dashboard — Ekraanipilt

![UrbanStyle CEO Dashboard](individual/week5_dashboard_screenshot.png)

*KPI kaardid (ülaosas) + müügitulu trend (keskel) + kanalite võrdlus + kaupluste jaotus (all)*

---

## 🔑 Key Insights (2023–2024, puhastatud andmed)

1. **+19.08% YoY kasv** — UrbanStyle kasvas 2024. aastal märkimisväärselt võrreldes 2023. aastaga. Kasvutrend on selge ja jätkusuutlik.

2. **AOV 287.53 €** — Keskmine tellimus on stabiilne kõigis kanalites ja kauplustes. See näitab ühtlast ostueelistust olenemata kanalist.

3. **Tallinn domineerib: 37.62%** — Tallinna kauplus moodustab üle kolmandiku kogu käibest. Suurim üksik segment kogu ettevõttes.

4. **Online kanal: 34.2% käibest** — E-pood on teine suurim segment ja kasvab kiiremini kui füüsilised kauplused. Tulevikupotentsiaal on alakasutatud.

5. **2 552 aktiivset klienti** — 18.8% registreerunud klientidest pole kunagi ostnud. See on selge turunduse kasvatamise võimalus.

---

## 📁 Failid

```
week5/
├── individual/
│   ├── week5_roll_a_ceo_dashboard.pbix     ← Power BI fail
│   ├── week5_dashboard_screenshot.png      ← ekraanipilt
│   └── week5_sql_queries.sql               ← andmepäringud
├── team/
│   └── week5_investor_dashboard_report.md  ← investori koondraport
└── README.md
```

---

## ▶️ How to Run

### Variant A — Power BI Desktop (soovitatav)

1. **Installi** [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (tasuta)
2. **Ava** fail `week5_roll_a_ceo_dashboard.pbix`
3. **Andmeallikas:** kui andmed ei laadi automaatselt:
   - `Transform Data` → `Data Source Settings`
   - Uuenda CSV failide asukoht oma arvutil
4. **Vaata** dashboardi — kõik KPI-d ja diagrammid laadivad automaatselt

### Variant B — SQL päringud (ilma Power BI-ta)

1. Ava `week5_sql_queries.sql`
2. Käivita Supabase SQL Editoris või mis tahes PostgreSQL kliendis
3. Päringud tagastavad samad andmed mis dashboardil:
   - Päring 1: KPI kaardid (kogutulu, kliendid, AOV, YoY)
   - Päring 2: Müügitrend kuude lõikes
   - Päring 3: Kanalite võrdlus
   - Päring 4: Kaupluste jaotus
   - Päring 5: Laoseisud kategooriate kaupa

### Andmed

- **Periood:** 2023–2024
- **Allikas:** UrbanStyle OÜ müügiandmed (Supabase / CSV)
- **Puhastamine:** duplikaadid eemaldatud, negatiivsed hinnad filtreeritud

---

## 🎨 Disainiotsused

| Valik | Põhjus |
|-------|--------|
| KPI kaardid ülaosas | CEO näeb 10 sekundiga kas kasvame |
| Joondiagramm trendile | Ajaline trend — joon on parim valik |
| Tulpdiagramm kanalitele | Võrdlus — tulp > sektor |
| Sektordiagramm kauplustele | Osa tervikust, 4 elementi |
| Teal (#009B8D) + Navy (#1A1A2E) | UrbanStyle brändipalett |
| Üks ekraan, null kerimist | Stakeholder ei peaks otsima infot |

---

## 🤖 AI kasutamine

Kasutasin Claude'i diagrammitüüpide valiku põhjendamiseks eri stakeholder'ite jaoks ja SQL päringute kirjutamiseks YoY kasvu arvutamiseks. AI selgitas data-ink ratio põhimõtet konkreetsete näidetega UrbanStyle andmete kontekstis.

