-- ============================================================
-- UrbanStyle | Week 6 | Power BI andmepäringud — kaupluste lood
-- Autor: Vladimir G | Periood: 2023–2024 | Puhastatud andmed
-- ============================================================


-- ============================================================
-- ROLL A: TALLINN
-- ============================================================

-- A1. Tallinna KPI kaardid
SELECT
    ROUND(SUM(total_price)::numeric, 2)        AS kogutulu,
    COUNT(sale_id)                              AS tellimusi,
    COUNT(DISTINCT customer_id)                 AS kliente,
    ROUND(AVG(total_price)::numeric, 2)         AS aov
FROM sales
WHERE store_location = 'Tallinn'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 1 017 706 € | 3 546 tellimust | 1 718 klienti | AOV 287.00 €

-- A2. Tallinna YoY kasv
SELECT
    ROUND(SUM(CASE WHEN sale_date < '2024-01-01' THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2023,
    ROUND(SUM(CASE WHEN sale_date >= '2024-01-01' THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2024
FROM sales
WHERE store_location = 'Tallinn'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 2023 → 462 801 € | 2024 → 517 595 € | YoY +11.8%

-- A3. Tallinna müügitrend kuude lõikes — joondiagramm
SELECT
    DATE_TRUNC('month', sale_date::date)       AS kuu,
    ROUND(SUM(total_price)::numeric, 2)         AS tulu
FROM sales
WHERE store_location = 'Tallinn'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- Parim kuu: detsember 2024 (64 171 €) — jõulukampaania tipp
-- Halvim kuu: veebruar 2023 (30 199 €)
-- Keskmine kuukäive: 42 404 €  ← viitejoon diagrammile

-- A4. Tallinna TOP 5 tooted — tulpdiagramm
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(s.total_price)::numeric, 2)       AS kogutulu,
    COUNT(s.sale_id)                             AS müüke
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.store_location = 'Tallinn'
  AND s.sale_date >= '2023-01-01'
  AND s.sale_date < '2025-01-01'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY kogutulu DESC
LIMIT 5;
-- TOP: Praktiline džersii seelik 10 221 € | Õhuline kõrge kontsaga kingad 9 918 €


-- ============================================================
-- ROLL B: TARTU
-- ============================================================

-- B1. Tartu KPI kaardid
SELECT
    ROUND(SUM(total_price)::numeric, 2)         AS kogutulu,
    COUNT(sale_id)                               AS tellimusi,
    COUNT(DISTINCT customer_id)                  AS kliente,
    ROUND(AVG(total_price)::numeric, 2)          AS aov
FROM sales
WHERE store_location = 'Tartu'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 489 361 € | 1 682 tellimust | 1 060 klienti | AOV 290.94 €

-- B2. Tartu müügitrend kuude lõikes — joondiagramm
SELECT
    DATE_TRUNC('month', sale_date::date)        AS kuu,
    ROUND(SUM(total_price)::numeric, 2)          AS tulu
FROM sales
WHERE store_location = 'Tartu'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- Parim kuu: detsember 2024 (33 047 €)
-- Halvim kuu: jaanuar 2023 (13 154 €)
-- Keskmine kuukäive: 20 390 € | YoY: +13.5%
-- Viitejoon: Tallinna keskmine 42 404 € (benchmark)

-- B3. Tartu TOP 5 tooted — tulpdiagramm
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(s.total_price)::numeric, 2)        AS kogutulu
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.store_location = 'Tartu'
  AND s.sale_date >= '2023-01-01'
  AND s.sale_date < '2025-01-01'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY kogutulu DESC
LIMIT 5;
-- TOP: Klassikaline seemisnahkne jooksutossud 5 637 €


-- ============================================================
-- ROLL C: PÄRNU
-- ============================================================

-- C1. Pärnu KPI kaardid
SELECT
    ROUND(SUM(total_price)::numeric, 2)          AS kogutulu,
    COUNT(sale_id)                                AS tellimusi,
    COUNT(DISTINCT customer_id)                   AS kliente,
    ROUND(AVG(total_price)::numeric, 2)           AS aov
FROM sales
WHERE store_location = 'Pärnu'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 272 867 € | 992 tellimust | 708 klienti | AOV 275.07 €

-- C2. Pärnu müügitrend kuude lõikes — hooajalisus
SELECT
    DATE_TRUNC('month', sale_date::date)         AS kuu,
    ROUND(SUM(total_price)::numeric, 2)           AS tulu
FROM sales
WHERE store_location = 'Pärnu'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- Parim kuu: august 2024 (17 102 €) — turismihooaeg!
-- Halvim kuu: jaanuar 2024 (5 647 €)
-- Keskmine kuukäive: 11 369 € ← viitejoon
-- YoY: +5.3% — aeglaseim kasv kõigist kauplustest

-- C3. Pärnu hooajaline võrdlus (suvi vs talv)
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM sale_date::date) IN (6,7,8) THEN 'Suvi (juuni-august)'
        WHEN EXTRACT(MONTH FROM sale_date::date) IN (12,1,2) THEN 'Talv (dets-veebr)'
        WHEN EXTRACT(MONTH FROM sale_date::date) IN (3,4,5) THEN 'Kevad (märts-mai)'
        ELSE 'Sügis (sept-nov)'
    END AS hooaeg,
    ROUND(SUM(total_price)::numeric, 2)           AS tulu,
    COUNT(sale_id)                                 AS tellimusi
FROM sales
WHERE store_location = 'Pärnu'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY 1
ORDER BY tulu DESC;

-- C4. Pärnu TOP 5 tooted
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(s.total_price)::numeric, 2)         AS kogutulu
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.store_location = 'Pärnu'
  AND s.sale_date >= '2023-01-01'
  AND s.sale_date < '2025-01-01'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY kogutulu DESC
LIMIT 5;
-- TOP: Õhuline goretex kingad 3 848 € | Praktiline kangast kingad 3 840 €


-- ============================================================
-- ROLL D: E-POOD (ONLINE)
-- ============================================================

-- D1. E-poe KPI kaardid
SELECT
    ROUND(SUM(total_price)::numeric, 2)           AS kogutulu,
    COUNT(sale_id)                                 AS tellimusi,
    COUNT(DISTINCT customer_id)                    AS kliente,
    ROUND(AVG(total_price)::numeric, 2)            AS aov
FROM sales
WHERE channel = 'online'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 925 183 € | 3 191 tellimust | 1 603 klienti | AOV 289.94 €

-- D2. E-poe YoY kasv
SELECT
    ROUND(SUM(CASE WHEN sale_date < '2024-01-01' THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2023,
    ROUND(SUM(CASE WHEN sale_date >= '2024-01-01' THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2024
FROM sales
WHERE channel = 'online'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 2023 → 379 538 € | 2024 → 513 765 € | YoY +35.4%
-- LEID: e-pood kasvab 3x kiiremini kui füüsilised kauplused!

-- D3. E-poe müügitrend kuude lõikes — kasvukurv
SELECT
    DATE_TRUNC('month', sale_date::date)          AS kuu,
    ROUND(SUM(total_price)::numeric, 2)            AS tulu
FROM sales
WHERE channel = 'online'
  AND sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- Parim kuu: detsember 2024 (63 205 €)
-- Halvim kuu: jaanuar 2023 (21 337 €)
-- Keskmine kuukäive: 38 549 €
-- Viitejoon: eesmärk 40% kogukäibest (praegu 34.2%)

-- D4. E-poe TOP 5 tooted
SELECT
    p.product_name,
    p.category,
    ROUND(SUM(s.total_price)::numeric, 2)          AS kogutulu,
    COUNT(s.sale_id)                                AS müüke
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.channel = 'online'
  AND s.sale_date >= '2023-01-01'
  AND s.sale_date < '2025-01-01'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY kogutulu DESC
LIMIT 5;
-- TOP: Õhuline sünteetiline sporditossud 12 154 € | Trendikas goretex oxfordid 9 276 €

-- D5. E-poe osakaal kogukäibest kuude lõikes
SELECT
    DATE_TRUNC('month', sale_date::date)           AS kuu,
    ROUND(SUM(CASE WHEN channel='online' THEN total_price ELSE 0 END)::numeric, 2) AS online_tulu,
    ROUND(SUM(total_price)::numeric, 2)             AS kokku_tulu,
    ROUND(SUM(CASE WHEN channel='online' THEN total_price ELSE 0 END)
          / SUM(total_price) * 100, 1)              AS online_osakaal_pct
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
