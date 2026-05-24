-- ============================================================
-- UrbanStyle | Week 1 | Roll A: Sales Data Explorer
-- Autor: Vladimir G | Tabel: sales
-- ============================================================


-- 1. Mitu rida on sales tabelis?
SELECT COUNT(*) AS ridade_arv
FROM sales;
-- Tulemus: 15 234 rida


-- 2. Millised veerud ja andmed tabelis on? (esimesed 10 rida)
SELECT *
FROM sales
LIMIT 10;
-- Veerud: sale_id, invoice_id, sale_date, customer_id, product_id,
--         quantity, unit_price, total_price, channel, store_location, payment_method


-- 3. Millised kauplused on esindatud ja mitu tehingut kummaski?
SELECT
    COALESCE(store_location, 'Online (tühi)') AS asukoht,
    COUNT(*) AS tehingute_arv
FROM sales
GROUP BY store_location
ORDER BY tehingute_arv DESC;
-- Tulemus:
--   Tallinn          → 5 704
--   NULL/Online      → 5 204  (online kanalil pole füüsilist asukohta)
--   Tartu            → 2 708
--   Pärnu            → 1 618


-- 4. Tallinna kaupluse 15 viimast tehingut
SELECT *
FROM sales
WHERE store_location = 'Tallinn'
ORDER BY sale_date DESC
LIMIT 15;


-- 5. 10 suurimat tehingut
SELECT *
FROM sales
ORDER BY total_price DESC
LIMIT 10;
-- Suurim tehing: 2 170.40 €


-- 6. 10 väikseimat tehingut — kas on negatiivseid?
SELECT *
FROM sales
ORDER BY total_price ASC
LIMIT 10;
-- LEID: miinimum on -1 405.32 € → 305 negatiivset tehingut tabelis
-- Tõenäoliselt tagastused (returns), kuid veergu "tüüp" pole — andmelünk


-- 7. Puuduvad väärtused: customer_id
SELECT
    COUNT(*)                        AS kokku_ridu,
    COUNT(customer_id)              AS kliendiga_ridu,
    COUNT(*) - COUNT(customer_id)   AS puuduv_klient
FROM sales;
-- Tulemus: 1 487 real puudub customer_id (~9.8% tehingutest)


-- 8. BOONUS — segased kuupäevavormingud (andmekvaliteedi probleem)
SELECT COUNT(*) AS mixed_dates
FROM sales
WHERE sale_date LIKE '__/__/____';
-- Tulemus: 457 rida kasutab DD/MM/YYYY vormingut (ülejäänud YYYY-MM-DD)
-- See tuleb hiljem Python/Power BI etapis puhastada


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 9. DISTINCT — millised müügikanalid tabelis esinevad?
SELECT DISTINCT channel
FROM sales;
-- Tulemus: 2 unikaalset kanalit → 'pood', 'online'
-- Märkus: online tehingutel puudub store_location (NULL) — see on loogiline


-- 10. COUNT — tehingute arv iga kaupluse kohta
SELECT
    COALESCE(store_location, 'Online (puudub)') AS kaupluse_asukoht,
    COUNT(*) AS tehinguid
FROM sales
GROUP BY store_location
ORDER BY tehinguid DESC;
-- Tulemus:
--   Tallinn          → 5 704
--   Online (puudub)  → 5 204
--   Tartu            → 2 708
--   Pärnu            → 1 618
-- Märkus: COALESCE asendab NULL väärtuse loetava tekstiga


-- 11. Kombineeritud tingimus — tehingud üle 100 EUR Tallinnas
SELECT *
FROM sales
WHERE total_price > 100
  AND store_location = 'Tallinn'
ORDER BY total_price DESC;
-- Tulemus: 4 555 tehingut
-- Suurim tehing selle filtri all: 1 872.70 €
