-- ============================================================
-- UrbanStyle | Week 4 | Roll B: Kliendigruppide analüüs
-- Autor: Vladimir G | Tabelid: customers, sales
-- ============================================================
-- Segmentide piirid (valitud AVG ja P75 põhjal):
--   AVG per klient: 1 541 € | P75: 1 888 € | P90: 2 833 €
--   VIP     > 5 000 € (selge kõrgekulutaja)
--   Regular > 1 000 € (üle keskmise)
--   Uus    <= 1 000 € (ühekordne või väike ostja)


-- 1. Kliendigruppide analüüs CTE + CASE WHEN segmenteerimine
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS nimi,
        c.city,
        COUNT(s.sale_id)                    AS tellimuste_arv,
        ROUND(SUM(s.total_price)::numeric, 2) AS kogukäive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
    nimi,
    city,
    tellimuste_arv,
    kogukäive,
    CASE
        WHEN kogukäive > 5000 THEN 'VIP'
        WHEN kogukäive > 1000 THEN 'Regular'
        ELSE 'Uus'
    END AS segment
FROM kliendi_kokkuvote
ORDER BY kogukäive DESC;
-- Tulemus:
--   VIP (>5 000 €):          52 klienti
--   Regular (1 000–5 000 €): 1 324 klienti
--   Uus (≤1 000 €):          1 182 klienti


-- 2. TOP 10 klienti (vähemalt 2 tellimust)
SELECT
    c.first_name || ' ' || c.last_name      AS nimi,
    c.city,
    COUNT(s.sale_id)                          AS tellimuste_arv,
    ROUND(SUM(s.total_price)::numeric, 2)     AS kogukäive
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING COUNT(s.sale_id) >= 2
ORDER BY kogukäive DESC
LIMIT 10;
-- TOP klient: Tiina Pärn (Tartu) | 114 tellimust | 39 951 €


-- 3. Segmentide koondstatistika
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.city,
        ROUND(SUM(s.total_price)::numeric, 2) AS kogukäive,
        CASE
            WHEN SUM(s.total_price) > 5000 THEN 'VIP'
            WHEN SUM(s.total_price) > 1000 THEN 'Regular'
            ELSE 'Uus'
        END AS segment
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.city
)
SELECT
    segment,
    COUNT(*)                                   AS klientide_arv,
    ROUND(AVG(kogukäive)::numeric, 2)          AS keskmine_käive,
    ROUND(SUM(kogukäive)::numeric, 2)          AS kokku_käive
FROM kliendi_kokkuvote
GROUP BY segment
ORDER BY kokku_käive DESC;
-- Tulemus:
--   Regular: 1 324 klienti | avg 2 088 € | kokku ~2 764 512 €
--   Uus:     1 182 klienti | avg   538 € | kokku ~   635 916 €
--   VIP:        52 klienti | avg 8 228 € | kokku ~   427 856 €
-- LEID: VIP on vaid 2% klientidest, kuid toob ~11% käibest


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 4. Klientide järjestus linna sees RANK() window function
WITH kliendi_kokkuvote AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name      AS nimi,
        c.city,
        ROUND(SUM(s.total_price)::numeric, 2)    AS kogukäive
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
SELECT
    nimi,
    city,
    kogukäive,
    RANK() OVER (
        PARTITION BY city
        ORDER BY kogukäive DESC
    ) AS koht_linnas
FROM kliendi_kokkuvote
ORDER BY city, koht_linnas
LIMIT 20;
-- Näitab iga linna TOP kliendid eraldi järjestuses
-- KOKKUVÕTE ANNALE:
-- 52 VIP klienti (2%) genereerivad ~11% käibest — need on UrbanStyle'i selgroog.
-- 1 324 Regular klienti (51%) toovad suurima osa käibest kokku.
-- 1 182 Uut klienti (46%) on konversioonipotentsiaal — nende käitumise uurimine
-- ja üleminek Regular segmenti peaks olema turunduse prioriteet nr 1.
