-- ============================================================
-- UrbanStyle | Week 2 | Roll C: Product Data Cleaner
-- Autor: Vladimir G | Tabel: products
-- ============================================================


-- Samm 1. Loo test koopia
CREATE TABLE products_test AS SELECT * FROM products;

SELECT COUNT(*) AS ridade_arv FROM products_test;
-- Tulemus: 362 rida


-- Samm 2. Leia duplikaadid — korduvad tootenimed
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
-- Tulemus: 12 duplikaatset tootenime
-- NB: sama nimi võib tähendada eri varianti (värv, suurus) — kontekst vajalik


-- Samm 3. Leia NULL väärtused kriitilistes väljades
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '')         AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL)                      AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL)                        AS null_omahind
FROM products_test;
-- Tulemus: null_nimi → 0 | null_kategooria → 0 | null_jaehind → 0 | null_omahind → 0


-- Samm 4. Kontrolli loogilisi vigu hindades
-- Negatiivsed hinnad?
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE retail_price < 0;
-- Tulemus: 0 negatiivset hinda

-- Äärmuslikud hinnad (> 1000 €)?
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;
-- Tulemus: 0 äärmuslikku hinda
-- Hinnavahemik on realistlik: 13.53 € – 434.08 €


-- Samm 5. Kategooriate järjekindlus
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;
-- Tulemus: 5 kategooriat, kõik järjekindlad (snake_case):
--   aksessuaarid → 67
--   jalanõusid   → 73
--   laste_riided → 70
--   meeste_riided→ 82
--   naiste_riided→ 70
-- LEID: kategooriad on tehniliselt puhtad, kuid kasutavad snake_case formaati
-- Soovitus: kaaluda INITCAP('Jalanõusid') aruannetes loetavuse parandamiseks


-- Samm 6. Puhastamisraport
-- ┌──────────────────────────┬──────────┬──────────────────────────────────────────┐
-- │ Kategooria               │ Probleeme│ Kirjeldus                                │
-- ├──────────────────────────┼──────────┼──────────────────────────────────────────┤
-- │ Duplikaatsed nimed       │ 12       │ Sama tootenimi mitu korda                │
-- │ NULL nimi / hind         │ 0        │ Kõik kriitilised väljad on täidetud      │
-- │ Loogilised vead (hinnad) │ 0        │ Negatiivseid ega äärmuslikke hindu pole  │
-- │ Ebajärjekindlad kategoor.│ 0        │ Kõik 5 kategooriat on ühtses formaadis  │
-- │ NULL omahind/kategooria  │ 0        │ Täielik                                  │
-- ├──────────────────────────┼──────────┼──────────────────────────────────────────┤
-- │ KOKKU probleeme          │ 12       │                                          │
-- └──────────────────────────┴──────────┴──────────────────────────────────────────┘
-- SOOVITUS: products on kolmest tabelist kõige puhtam.
-- Prioriteet: 12 duplikaatset nime — kontrollida, kas tegemist on eri variantidega
-- või tõeliste duplikaatidega.


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================

-- Kategooriate standardiseerimine (snake_case → loetav)
UPDATE products_test
SET category = CASE
    WHEN category = 'jalanõusid'    THEN 'Jalanõusid'
    WHEN category = 'meeste_riided' THEN 'Meeste riided'
    WHEN category = 'naiste_riided' THEN 'Naiste riided'
    WHEN category = 'laste_riided'  THEN 'Laste riided'
    WHEN category = 'aksessuaarid'  THEN 'Aksessuaarid'
    ELSE INITCAP(TRIM(category))
END;

-- Kontrolli tulemust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;
