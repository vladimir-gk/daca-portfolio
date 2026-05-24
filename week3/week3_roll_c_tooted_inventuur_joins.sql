-- ============================================================
-- UrbanStyle | Week 3 | Roll C: Tooted + Inventuur (LEFT JOIN)
-- Autor: Vladimir G | Tabelid: products, sales, inventory
-- ============================================================


-- 1. Tooted, mis pole kunagi müüdud
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
-- Tulemus: 12 toodet pole kunagi müüdud
-- Kategooriad: aksessuaarid (5), jalanõusid (2), naiste_riided (2),
--              laste_riided (2), meeste_riided (1)


-- 2. Müümata toodete arv
SELECT COUNT(DISTINCT p.product_id) AS müümata_tooteid
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;
-- Tulemus: 12 toodet (3.3% kataloogist)


-- 3. TOP 10 enim müüdud toodet
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(s.sale_id)                      AS müüdud_kordi,
    ROUND(SUM(s.total_price)::numeric, 2) AS kogumüük
FROM products p
INNER JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;
-- TOP 3:
--   Trendikas goretex oxfordid      | 56 müüki | 43 042 €
--   Õhuline sünteetiline sporditoss | 51 müüki | 41 238 €
--   Luksuslik villane pahkluu saapad| 47 müüki | 35 692 €


-- 4. Kategooriate analüüs
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)          AS tooteid,
    COUNT(s.sale_id)                       AS müüke,
    ROUND(SUM(s.total_price)::numeric, 2)  AS kogumüük
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY kogumüük DESC;
-- Tulemus:
--   meeste_riided: 82 toodet | 2 044 müüki → suurim müük
--   jalanõusid:    73 toodet | 1 792 müüki → kõrgeim keskmine hind
--   naiste_riided: 70 toodet | 1 790 müüki
--   aksessuaarid:  67 toodet | 1 611 müüki
--   laste_riided:  70 toodet | 1 790 müüki → madalaim kogumüük


-- 5. Inventuuri staatus — mis vajab tellimist?
SELECT
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    CASE
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;
-- Tulemus: 231 toodet vajab tellimist (quantity_available <= reorder_point)


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 6. Kolme tabeli JOIN: müümata tooted, mis on laos (kinni olev raha)
SELECT
    p.product_name,
    p.category,
    p.retail_price,
    i.quantity_available,
    ROUND((p.retail_price * i.quantity_available)::numeric, 2) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC;
-- Tulemus: kõik 12 müümata toodet on laos 0 ühikut → kinni olevat raha pole
-- LEID: müümata tooted on juba laost otsas — need pole mitte laoseis-probleem,
-- vaid kataloogist eemaldamise kandidaadid (tooted eksisteerivad ainult andmebaasis)
-- ÄRILINE JÄRELDUS: 12 toodet (3.3% kataloogist) pole kunagi müüdud ja laos 0.
-- Soovitus: eemaldada need kataloogist — need tekitavad segadust ja moonutavad
-- kategooria analüüse. Prioriteet tellimiseks: 231 toodet on kriitilises laoseisus.
