-- ============================================================
-- UrbanStyle | Week 4 | Roll C: Inventuuristatistika
-- Autor: Vladimir G | Tabelid: products, sales, inventory
-- NB: Ülesandes viidatakse 'inventorymovements' tabelile,
--     tegelik tabel on 'inventory' — kasutatakse seda.
-- NB: Tabelis puudub veerg 'price' — kasutatakse 'retail_price'
-- ============================================================


-- 1. Tootekategooriate koondandmed
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)              AS tooteid,
    ROUND(AVG(p.retail_price)::numeric, 2)    AS keskmine_hind,
    MIN(p.retail_price)                        AS min_hind,
    MAX(p.retail_price)                        AS max_hind
FROM products p
GROUP BY p.category
ORDER BY tooteid DESC;
-- Tulemus:
--   meeste_riided: 82 toodet | avg 190 € | min 49 € | max 375 €
--   jalanõusid:    73 toodet | avg 214 € | min 58 € | max 434 €
--   laste_riided:  70 toodet | avg  85 € | min 23 € | max 169 €
--   naiste_riided: 70 toodet | avg 193 € | min 33 € | max 351 €
--   aksessuaarid:  67 toodet | avg 126 € | min 14 € | max 231 €


-- 2. Müüdud kogused kategooriate kaupa (HAVING filtriga)
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)              AS tooteid,
    SUM(s.quantity)                            AS müüdud_kogus,
    ROUND(AVG(s.quantity)::numeric, 2)         AS avg_kogus_toote_kohta,
    ROUND(SUM(s.total_price)::numeric, 2)      AS kogukäive
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 3000
ORDER BY kogukäive DESC;
-- Tulemus (HAVING > 3 000 müüdud ühikut):
--   jalanõusid:    71 toodet | 4 614 ühikut | 1 171 288 €
--   meeste_riided: 81 toodet | 4 978 ühikut | 1 131 049 €
--   naiste_riided: 68 toodet | 4 420 ühikut | 1 025 489 €
--   laste_riided:  68 toodet | 4 498 ühikut |   460 138 €
-- aksessuaarid jääb HAVING filtrist välja (alla 3 000 ühiku)


-- 3. Laoseis kategooriate kaupa
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)              AS tooteid,
    SUM(i.quantity_available)                  AS laos_kokku,
    SUM(CASE WHEN i.quantity_available <= i.reorder_point
             THEN 1 ELSE 0 END)               AS tellimist_vajab
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.category
ORDER BY laos_kokku DESC;
-- Tulemus:
--   meeste_riided: 82 toodet | 52 848 laos | 10 tellimist vajab
--   jalanõusid:    73 toodet | 33 629 laos |  8 tellimist vajab
--   naiste_riided: 70 toodet | 30 175 laos |  5 tellimist vajab
--   laste_riided:  70 toodet | 26 907 laos |  8 tellimist vajab
--   aksessuaarid:  67 toodet | 18 775 laos |  9 tellimist vajab


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 4. Toodete järjestus kategooria sees ROW_NUMBER() window function
SELECT
    p.product_name,
    p.category,
    p.retail_price,
    ROW_NUMBER() OVER (
        PARTITION BY p.category
        ORDER BY p.retail_price DESC
    ) AS koht_kategoorias
FROM products p
ORDER BY p.category, koht_kategoorias
LIMIT 20;


-- 5. TOP 3 tooted igas kategoorias müügi järgi
WITH toote_myyk AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        ROUND(SUM(s.total_price)::numeric, 2) AS kogukäive,
        COUNT(s.sale_id)                       AS müüke
    FROM products p
    JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
jarjestus AS (
    SELECT *,
        RANK() OVER (PARTITION BY category ORDER BY kogukäive DESC) AS koht
    FROM toote_myyk
)
SELECT category, product_name, kogukäive, müüke, koht
FROM jarjestus
WHERE koht <= 3
ORDER BY category, koht;
-- TOP tooted kategooriate kaupa:
--   jalanõusid:    Trendikas goretex oxfordid (43 042 €) | Õhuline sporditoss (41 238 €)
--   meeste_riided: Luksuslik puuvillane linane särk (30 391 €)
--   naiste_riided: Praktiline viskoosne jakk (32 590 €)
--   aksessuaarid:  Stiilne puust müts (25 736 €)
--   laste_riided:  Mugav softshell slim-fit püksid (16 811 €)
-- KOKKUVÕTE ANNALE:
-- Jalanõusid on kõrgeima keskmise hinnaga (214 €) ja 2. kohal käibelt (1 171 288 €).
-- Meeste riided on müügimahtudelt suurim (3 401 müüki), kuid käibelt teine.
-- 40 toodet kõigis kategooriates on kriitilises laoseisus — tellimused vajalikud.
-- Soovitus: jalanõude kategooria vajab lisatähelepanu laohalduses (kõrgeim hind,
-- suurim risk müügikao tekkeks puuduse korral).
