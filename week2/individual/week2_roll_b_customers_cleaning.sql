-- ============================================================
-- UrbanStyle | Week 2 | Roll B: Customer Data Cleaner
-- Autor: Vladimir G | Tabel: customers
-- ============================================================


-- Samm 1. Loo test koopia
CREATE TABLE customers_test AS SELECT * FROM customers;

SELECT COUNT(*) AS ridade_arv FROM customers_test;
-- Tulemus: 3 150 rida


-- Samm 2. Leia duplikaatsed e-mailid
SELECT email, COUNT(*) AS koopiate_arv
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
-- Tulemus: 128 duplikaatset e-maili — võimalikud topeltregistreerimised


-- Samm 3. Leia puuduvad nimed
SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '')   AS null_perenimi
FROM customers_test;
-- Tulemus: null_eesnimi → 0 | null_perenimi → 0


-- Samm 4. Kontrolli linnade nimekujusid
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;
-- LEID: 54 erinevat nimekuju 12 linnale
-- Näited: 'Tallinn', 'tallinn', 'TALLINN', ' Tallinn', 'Tallinn '
-- Geograafiline analüüs on moonutatud kuni puhastamiseni


-- Samm 5. Kontrolli kontaktandmeid
SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email
FROM customers_test;
-- Tulemus: null_telefon → 0 | null_email → 380 (~12.1%)


-- Samm 6. Puhastamisraport
-- ┌──────────────────────────┬──────────┬──────────────────────────────────────────┐
-- │ Kategooria               │ Probleeme│ Kirjeldus                                │
-- ├──────────────────────────┼──────────┼──────────────────────────────────────────┤
-- │ Duplikaatsed e-mailid    │ 128      │ Sama e-mail mitmel kliendil              │
-- │ NULL eesnimi             │ 0        │ Kõik eesnimed on olemas                  │
-- │ NULL perenimi            │ 0        │ Kõik perenimed on olemas                 │
-- │ Ebajärjekindlad linnad   │ 54       │ Erinevad nimekujud (tallinn vs Tallinn)  │
-- │ NULL e-mail              │ 380      │ Puuduvad kontaktandmed                   │
-- │ NULL telefon             │ 0        │ Kõik telefoninumbrid on olemas           │
-- ├──────────────────────────┼──────────┼──────────────────────────────────────────┤
-- │ KOKKU probleeme          │ 562      │                                          │
-- └──────────────────────────┴──────────┴──────────────────────────────────────────┘
-- SOOVITUS: Kõige suurem igapäevane mõju — linnanimed (54 varianti).
-- Geograafiline aruandlus annab praegu valesid tulemusi.


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================

-- Ühtlusta linnanimed INITCAP + TRIM abil
UPDATE customers_test
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

-- Kontrolli tulemust
SELECT city, COUNT(*) AS arv
FROM customers_test
GROUP BY city
ORDER BY city;

-- Standardiseeri e-mailid väiketähtedeks
UPDATE customers_test
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));

-- Telefoninumbrite standardiseerimine
SELECT phone,
    CASE
        WHEN phone LIKE '+372%' THEN phone
        WHEN phone LIKE '372%' THEN '+' || phone
        WHEN LENGTH(phone) = 7  THEN '+372' || phone
        ELSE phone
    END AS standardne_telefon
FROM customers_test
WHERE phone IS NOT NULL
LIMIT 10;
