-- ============================================================
-- UrbanStyle | Week 1 | Roll B: Customer Data Explorer
-- Autor: Vova | Tabel: customers
-- ============================================================


-- 1. Mitu klienti on kokku?
SELECT COUNT(*) AS klientide_arv
FROM customers;
-- Tulemus: 3 150 klienti


-- 2. Millised veerud ja andmed tabelis on? (esimesed 10 rida)
SELECT *
FROM customers
LIMIT 10;
-- Veerud: customer_id, first_name, last_name, email, phone,
--         city, registration_date, loyalty_tier, birth_year


-- 3. Millised linnad on esindatud? (unikaalsed väärtused)
SELECT DISTINCT city
FROM customers
ORDER BY city;
-- LEID: sama linn esineb mitmes variandis — 'Tallinn', 'tallinn', 'TALLINN', ' Tallinn'
-- Andmepuhastus on vajalik enne analüüsi!


-- 4. Tallinna kliendid, sorteeritud perekonnanime järgi
SELECT *
FROM customers
WHERE city = 'Tallinn'
ORDER BY last_name ASC
LIMIT 15;
-- Märkus: WHERE 'Tallinn' ei leia 'tallinn' ega 'TALLINN' — kirjaviisi probleem!


-- 5. Vanim ja uusim registreerimine
SELECT
    MIN(registration_date) AS vanim_registreering,
    MAX(registration_date) AS uusim_registreering
FROM customers;
-- Tulemus: vanim → 2020-01-02 | uusim → 2025-02-27


-- 6. Puuduvad väärtused: eesnimi ja e-mail
SELECT COUNT(*) - COUNT(first_name) AS puuduvad_eesnimed
FROM customers;
-- Tulemus: 0 — kõigil klientidel on eesnimi olemas

SELECT COUNT(*) - COUNT(email) AS puuduvad_emailid
FROM customers;
-- Tulemus: 380 kliendil puudub e-mail (~12.1% klientidest)


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 7. Duplikaatsed e-mailid
SELECT
    COUNT(*)            AS kokku_emaile,
    COUNT(DISTINCT email) AS unikaalseid_emaile,
    COUNT(*) - COUNT(DISTINCT email) AS duplikaadid
FROM customers;
-- Tulemus: kokku 2 770 emaili | unikaalseid 2 640 | duplikaate: 130
-- LEID: 130 duplikaati — võimalikud topelt registreerimised!


-- 8. Klientide arv linniti
SELECT
    city,
    COUNT(*) AS klientide_arv
FROM customers
GROUP BY city
ORDER BY klientide_arv DESC;
-- LEID: Tallinn → 1 135, kuid lisaks veel 'tallinn' (26), 'TALLINN' (23), ' Tallinn' (23)
-- Tegelik Tallinna klientide arv on suurem — kirjaviisi ebajärjepidevus moonutab tulemusi
-- Puhastatud analüüs peaks kasutama: LOWER(TRIM(city))


-- 9. Uuemad kliendid — registreeritud alates 2024-07-01
SELECT *
FROM customers
WHERE registration_date >= '2024-07-01'
ORDER BY registration_date DESC;
-- Tulemus: 425 klienti registreeritud viimase ~8 kuuga
