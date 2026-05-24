-- ============================================================
-- UrbanStyle | Week 1 | Roll C: Product Data Explorer
-- Autor: Vladimir G | Tabel: products
-- ============================================================
-- NB: Tabelis puudub veerg 'price' — kasutatakse 'retail_price'
--     Lisaveerud: cost_price, subcategory, supplier, eco_certified


-- 1. Mitu toodet on kokku?
SELECT COUNT(*) AS toodete_arv
FROM products;
-- Tulemus: 362 toodet


-- 2. Millised veerud ja andmed tabelis on? (esimesed 10 rida)
SELECT *
FROM products
LIMIT 10;
-- Veerud: product_id, product_name, category, subcategory,
--         supplier, cost_price, retail_price, eco_certified, created_at


-- 3. Kõik unikaalsed tootekategooriad
SELECT DISTINCT category
FROM products
ORDER BY category;
-- Tulemus: 5 kategooriat →
--   aksessuaarid, jalanõusid, laste_riided, meeste_riided, naiste_riided


-- 4. 10 kallemat toodet
SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price DESC
LIMIT 10;
-- Kalleim toode: 'Õhuline sünteetiline sporditossud' (jalanõusid) → 434.08 €


-- 5. 10 odavamat toodet
SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price ASC
LIMIT 10;
-- Odavaim toode: aksessuaarid → 13.53 €


-- 6. Kõik jalanõude kategooria tooted (üle 50 EUR), sorteeritud hinna järgi
SELECT *
FROM products
WHERE category = 'jalanõusid'
ORDER BY retail_price DESC;
-- Tulemus: 73 toodet | hinnavahemik 58.49 € — 434.08 €


-- 7. Puuduvad väärtused
SELECT COUNT(*) - COUNT(retail_price) AS puuduvad_hinnad
FROM products;
-- Tulemus: 0 — kõigil toodetel on hind olemas

SELECT COUNT(*) - COUNT(category) AS puuduvad_kategooriad
FROM products;
-- Tulemus: 0 — kõigil toodetel on kategooria olemas


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 8. Toodete arv kategooriati
SELECT
    category,
    COUNT(*) AS toodete_arv
FROM products
GROUP BY category
ORDER BY toodete_arv DESC;
-- Tulemus:
--   meeste_riided  → 82
--   jalanõusid     → 73
--   laste_riided   → 70
--   naiste_riided  → 70
--   aksessuaarid   → 67


-- 9. Hinnastatistika kategooriati
SELECT
    category,
    COUNT(*)                    AS toodete_arv,
    MIN(retail_price)           AS min_hind,
    ROUND(AVG(retail_price), 2) AS kesk_hind,
    MAX(retail_price)           AS max_hind
FROM products
GROUP BY category
ORDER BY max_hind DESC;
-- Tulemus:
--   jalanõusid    → min 58.49 | avg 214.10 | max 434.08
--   meeste_riided → min 48.85 | avg 189.91 | max 374.54
--   naiste_riided → min 32.93 | avg 192.58 | max 351.33
--   aksessuaarid  → min 13.53 | avg 125.71 | max 231.13
--   laste_riided  → min 22.70 | avg  85.30 | max 168.82


-- 10. Kombineeritud tingimus: jalanõud üle 50 EUR
SELECT *
FROM products
WHERE retail_price > 50
  AND category = 'jalanõusid'
ORDER BY retail_price DESC;
-- Tulemus: kõik 73 jalanõu toodet on üle 50 EUR


-- 11. BOONUS — ökomärgistusega toodete jaotus
SELECT
    eco_certified,
    COUNT(*) AS toodete_arv
FROM products
GROUP BY eco_certified
ORDER BY toodete_arv DESC;
-- Tulemus: false → 242 | true → 102 | NULL → 18
-- ~28% toodetest on ökomärgistusega — võimalik turundusargument
