-- ============================================================
-- UrbanStyle | Week 3 | Roll B: Kadunud kliendid (LEFT JOIN)
-- Autor: Vladimir G | Tabelid: customers, sales
-- ============================================================


-- 1. LEFT JOIN: kõik kliendid, ka need kellel pole oste
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date,
    s.sale_id
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
-- Kui sale_id on NULL → klient pole kunagi ostnud


-- 2. Kadunud klientide koguarv
SELECT COUNT(DISTINCT c.customer_id) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
-- Tulemus: 592 klienti (~18.8% kõigist registreeritud klientidest)


-- 3. Kadunud kliendid linnade kaupa
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;
-- Tulemus (TOP 3):
--   Tallinn: 221 kadunud klienti
--   Tartu:   125 kadunud klienti
--   Pärnu:    65 kadunud klienti
-- Proportsioon: sama mis aktiivsete klientide jaotus — probleemil pole geograafilist eripära


-- 4. Millal kadunud kliendid registreerusid?
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.registration_date,
    c.city,
    c.loyalty_tier
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;
-- LEID: suurem osa kadunud klientidest registreerus 2024 lõpus ja 2025 alguses


-- 5. Aktiivne vs kadunud klientide võrdlus
SELECT
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END AS staatus,
    COUNT(DISTINCT c.customer_id) AS kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END;
-- Tulemus:
--   Aktiivne:  2 558 klienti (81.2%)
--   Kadunud:     592 klienti (18.8%)


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 6. Kadunud kliendid registreerimiskuu kaupa
SELECT
    DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu,
    COUNT(DISTINCT c.customer_id)             AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY DATE_TRUNC('month', c.registration_date)
ORDER BY registreerimis_kuu DESC;
-- LEID (TOP kuud):
--   2025-01: 53 kadunud klienti
--   2024-12: 53 kadunud klienti
--   2025-02: 47 kadunud klienti
--   2024-11: 44 kadunud klienti
-- ÄRILINE JÄRELDUS: 18.8% registreeritud klientidest pole kunagi ostnud.
-- Kontsentreerub viimastele kuudele — tõenäoliselt kliendid, kes registreerusid
-- kampaania ajal aga ei sooritanud esimest ostu.
-- Soovitus Annale: käivitada "esimese ostu" e-mail kampaania neile 592 kliendile
-- koos allahindlusega — konversioon isegi 20% annaks ~118 uut ostjat.
