# Week 3 | Meeskonna JOIN-analüüsi kokkuvõte

## Ülevaade

| Roll | Fookus | Peamine leid |
|------|--------|--------------|
| A | INNER JOIN: müük + kliendid | TOP klient: 39 951 € | 34% klientidest üle keskmise |
| B | LEFT JOIN: kadunud kliendid | 592 klienti (18.8%) pole kunagi ostnud |
| C | LEFT JOIN: tooted + inventuur | 12 müümata toodet, 231 kriitilises laoseisus |
| D | 3 tabeli JOIN: kanalid | Pood: 1 245 €/klient vs online: 882 €/klient |

## Rollide kokkuvõte

**Roll A — Müük + Kliendid (INNER JOIN)**
- TOP klient: Tiina Pärn (Tartu) — 39 951 €, 114 ostu
- Tallinn domineerib: 968 klienti, 1 464 161 € (~49% kogu müügist)
- 34% klientidest kulutavad üle keskmise (1 540 €) — VIP segment
- loyalty_tier "määramata" on suurim grupp (1 027 klienti, 1 628 044 €) — klassifitseerimine puudulik

**Roll B — Kadunud kliendid (LEFT JOIN)**
- 592 klienti (18.8%) pole kunagi ostnud
- Kontsentreerunud 2024 Q4 ja 2025 Q1 — kampaania-registreerijad, kes ei konverteerunud
- Suurim kadunud kliente: Tallinn (221), Tartu (125), Pärnu (65)
- Soovitus: "esimese ostu" kampaania 20% konversiooniga → ~118 uut ostjat

**Roll C — Tooted + Inventuur (LEFT JOIN + 3 tabelit)**
- 12 toodet pole kunagi müüdud, laos 0 ühikut → eemaldada kataloogist
- TOP toode: Trendikas goretex oxfordid (43 042 €, 56 müüki)
- 231 toodet kriitilises laoseisus (quantity_available ≤ reorder_point)
- Jalanõusid on müügimahult 2. kohal, kuid kõrgeima keskmise hinnaga

**Roll D — Müügikanalid (3 tabeli JOIN)**
- Pood: 2 847 956 € (65.8%) | Online: 1 526 276 € (34.2%)
- Pood efektiivsem per klient: 1 245 € vs 882 € (+41%)
- Online tugevam jalanõudes: 403 € keskmine vs 366 € poods
- Tartu ja Pärnu online-potentsiaal alakasutatud

## Soovitused juhtkonnale (Anna + Toomas)

| Prioriteet | Soovitus | Mõju |
|------------|----------|------|
| 🔴 1 | "Esimese ostu" kampaania 592 kadunud kliendile | +~118 uut ostjat |
| 🔴 2 | VIP programm 34%-le üle-keskmise kulutajatest | Lojaalsuse kasv |
| 🟡 3 | Online turundus suunata jalanõude kategooriasse | Kõrgem AOV |
| 🟡 4 | 231 toodet kriitilises laoseisus — tellida juurde | Müügivõimaluste kaotamine |
| 🟢 5 | Eemaldada 12 müümata toodet kataloogist | Andmete puhtus |

