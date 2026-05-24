-- ============================================================
-- UrbanStyle | Week 1 | Roll D: Sales Dimensions Explorer
-- Autor: Vladimir G | Tabel: sales
-- Fookus: channel, store_location, payment_method
-- ============================================================


-- 1. Kanalid, asukohad ja makseviisid — ülevaade (esimesed 10 rida)
SELECT channel, store_location, payment_method
FROM sales
LIMIT 10;


-- 2. Unikaalsed müügikanalid
SELECT DISTINCT channel
FROM sales;
-- Tulemus: 2 kanalit → 'pood', 'online'


-- 3. Unikaalsed kaupluste asukohad
SELECT DISTINCT store_location
FROM sales;
-- Tulemus: Tallinn, Tartu, Pärnu + NULL
-- NB: NULL tähendab online-müüki — veebipoel pole füüsilist asukohta


-- 4. Unikaalsed makseviisid
SELECT DISTINCT payment_method
FROM sales;
-- Tulemus: 3 makseviisi → 'kaart', 'sularaha', 'järelmaks'
-- Jaotus on üllatavalt ühtlane — ükski makseviis ei domineeri selgelt


-- 5. Online-müügid — 15 suurimat tehingut
SELECT *
FROM sales
WHERE channel = 'online'
ORDER BY total_price DESC
LIMIT 15;


-- 6. Tehingud ilma kaupluse asukohata (NULL)
SELECT COUNT(*) AS puuduv_asukoht
FROM sales
WHERE store_location IS NULL;
-- Tulemus: 5 204 tehingut (~34.2% kõigist)
-- Selgitus: kõik online-tehingud → store_location on NULL (loogiline)


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 7. Tehingute arv kaupluse asukoha kaupa (ainult füüsilised poed)
SELECT
    store_location,
    COUNT(*) AS tehinguid
FROM sales
WHERE store_location IS NOT NULL
ORDER BY tehinguid DESC;
-- Tulemus:
--   Tallinn → 5 704 (56.9% füüsilistest müükidest)
--   Tartu   → 2 708 (27.0%)
--   Pärnu   → 1 618 (16.1%)


-- 8. Online vs pood — tehingute arvu võrdlus
SELECT
    channel,
    COUNT(*) AS tehinguid,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS osakaal_protsent
FROM sales
GROUP BY channel
ORDER BY tehinguid DESC;
-- Tulemus:
--   pood   → 10 030 tehingut (65.8%)
--   online →  5 204 tehingut (34.2%)
-- Füüsiline kauplus domineerib, kuid online on märkimisväärne segment


-- 9. Makseviisi jaotus
SELECT
    payment_method,
    COUNT(*) AS tehinguid
FROM sales
GROUP BY payment_method
ORDER BY tehinguid DESC;
-- Tulemus:
--   kaart      → 5 129 (33.7%)
--   sularaha   → 5 108 (33.5%)
--   järelmaks  → 4 997 (32.8%)
-- LEID: kõik kolm makseviisi on praktiliselt võrdselt esindatud — haruldane tasakaal


-- 10. Kombineeritud tingimus: sularahamaksed Tartus
SELECT *
FROM sales
WHERE payment_method = 'sularaha'
  AND store_location = 'Tartu'
ORDER BY total_price DESC
LIMIT 10;
-- Suurim sularahatehing Tartus: 1 736.32 €
