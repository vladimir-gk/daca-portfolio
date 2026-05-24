-- ============================================================
-- UrbanStyle | Week 3 | Roll A: Müük + Kliendid (INNER JOIN)
-- Autor: Vladimir G | Tabelid: sales, customers
-- ============================================================


-- 1. Lihtne INNER JOIN: kliendid, kes on ostnud
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
LIMIT 20;
-- NB: INNER JOIN tagastab AINULT read, kus mõlemas tabelis on vastav kirje.
-- 1 487 NULL customer_id jäävad välja — need on külalisostud.


-- 2. TOP 10 klienti kogumüügi järgi
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    COUNT(DISTINCT s.sale_id)          AS ostude_arv,
    ROUND(SUM(s.total_price)::numeric, 2) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY kogumüük DESC
LIMIT 10;
-- Tulemus (TOP 5):
--   Tiina Pärn   | tartu   | 114 ostu | 39 950.99 €
--   Priit Rand   | Pärnu   | 114 ostu | 37 697.12 €
--   Anu Kuusik   | Tallinn | 125 ostu | 36 501.83 €
--   Laura Tammik | Pärnu   | 114 ostu | 35 766.50 €
--   Kevin Org    | Tallinn | 118 ostu | 35 195.99 €


-- 3. Müük linnade kaupa
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id)         AS kliente,
    COUNT(s.sale_id)                       AS oste,
    ROUND(SUM(s.total_price)::numeric, 2)  AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogumüük DESC;
-- Tulemus (TOP 3):
--   Tallinn: 968 klienti | 5 231 ostu | 1 464 161 €
--   Tartu:   499 klienti | 2 431 ostu |   703 262 €
--   Pärnu:   263 klienti | 1 821 ostu |   548 413 €
-- LEID: Tallinn moodustab ~49% kogu müügist


-- 4. Müük lojaalsustasemete kaupa
SELECT
    COALESCE(NULLIF(c.loyalty_tier, ''), 'määramata') AS lojaalsustase,
    COUNT(DISTINCT c.customer_id)                      AS kliente,
    ROUND(SUM(s.total_price)::numeric, 2)              AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY kogumüük DESC;
-- Tulemus:
--   määramata: 1 027 klienti | 1 628 044 € — suurim grupp, klassifitseerimata!
--   silver:      562 klienti |   870 400 €
--   gold:        492 klienti |   809 984 €
--   bronze:      477 klienti |   632 375 €
-- LEID: gold kliendid kulutavad rohkem per klient kui silver


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 5. Alamjärjepäring: kliendid, kelle kogumüük on üle keskmise
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    ROUND(SUM(s.total_price)::numeric, 2) AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > (
    SELECT AVG(kliendi_müük)
    FROM (
        SELECT SUM(total_price) AS kliendi_müük
        FROM sales
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ) AS keskmised
)
ORDER BY kogumüük DESC;
-- Tulemus: 869 klienti üle keskmise (34.0% kõigist ostjatest)
-- Keskmine ostusumma per klient: 1 540.58 €
-- ÄRILINE JÄRELDUS: 34% klientidest genereerivad ebaproportsionaalselt suure osa
-- müügist — Anna peaks suunama lojaalsusprogrammi just neile.
-- Soovitus: luua "VIP" segment ja pakkuda neile eeliseid enne avalikke kampaaniaid.
