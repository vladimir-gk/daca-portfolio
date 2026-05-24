-- ============================================================
-- UrbanStyle | Week 5 | Power BI andmepäringud
-- Autor: Vladimir G | Tabelid: sales, customers, products, inventory
-- Periood: 2023–2024 | Andmed: puhastatud duplikaatidest
-- ============================================================


-- 1. KPI kaardid — kogutulu, klientide arv, AOV (Roll A + D)
SELECT
    ROUND(SUM(total_price)::numeric, 2)           AS kogutulu,
    COUNT(DISTINCT customer_id)                    AS aktiivsed_kliendid,
    ROUND(AVG(total_price)::numeric, 2)            AS keskmine_tellimus,
    COUNT(sale_id)                                 AS tehinguid
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: kogutulu ~2.91M € | kliendid 2 552 | AOV 287.53 €


-- 2. YoY kasv (2023 vs 2024) — KPI kaart (Roll A)
SELECT
    ROUND(SUM(CASE WHEN sale_date >= '2023-01-01'
                    AND sale_date < '2024-01-01'
               THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2023,
    ROUND(SUM(CASE WHEN sale_date >= '2024-01-01'
                    AND sale_date < '2025-01-01'
               THEN total_price ELSE 0 END)::numeric, 2) AS tulu_2024,
    ROUND(
        (SUM(CASE WHEN sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
                  THEN total_price ELSE 0 END)
         - SUM(CASE WHEN sale_date >= '2023-01-01' AND sale_date < '2024-01-01'
                    THEN total_price ELSE 0 END))
        / SUM(CASE WHEN sale_date >= '2023-01-01' AND sale_date < '2024-01-01'
                   THEN total_price ELSE 0 END) * 100, 2
    ) AS yoy_kasv_protsent
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01';
-- Tulemus: 2023 → 2024 kasv +19.08%


-- 3. Müügitulu trend kuude lõikes — joondiagramm (Roll A)
SELECT
    DATE_TRUNC('month', sale_date::date)           AS kuu,
    ROUND(SUM(total_price)::numeric, 2)            AS tulu
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- 24 rida (kuud) — Power BI joondiagrammi andmeallikas


-- 4. Müük kanalite lõikes — tulpdiagramm (Roll B)
SELECT
    channel                                        AS müügikanal,
    COUNT(DISTINCT customer_id)                    AS kliente,
    COUNT(sale_id)                                 AS tehinguid,
    ROUND(SUM(total_price)::numeric, 2)            AS kogutulu
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY channel
ORDER BY kogutulu DESC;
-- Tulemus: pood 1.90M € | online 1.01M €


-- 5. Müük kaupluste lõikes — sektordiagramm (Roll C)
SELECT
    COALESCE(store_location, 'Online')             AS kauplus,
    ROUND(SUM(total_price)::numeric, 2)            AS kogutulu,
    COUNT(sale_id)                                 AS tehinguid
FROM sales
WHERE sale_date >= '2023-01-01'
  AND sale_date < '2025-01-01'
GROUP BY store_location
ORDER BY kogutulu DESC;
-- Tulemus: Tallinn 37.62% | Online 34.2% | Tartu 18.09% | Pärnu 10.09%


-- 6. Laoseisud kategooriate lõikes — tulpdiagramm (Roll C)
SELECT
    p.category,
    SUM(i.quantity_available)                      AS laos_kokku,
    COUNT(CASE WHEN i.quantity_available <= i.reorder_point
               THEN 1 END)                         AS kriitilised_tooted
FROM products p
LEFT JOIN inventory i ON p.product_id = i.product_id
GROUP BY p.category
ORDER BY laos_kokku DESC;
-- Meeste_riided: suurim laovaru | Aksessuaarid: väikseim


-- 7. Klientide registreerumine kuude lõikes — uute klientide trend (Roll B)
SELECT
    DATE_TRUNC('month', registration_date::date)   AS kuu,
    COUNT(customer_id)                             AS uusi_kliente
FROM customers
WHERE registration_date >= '2023-01-01'
  AND registration_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', registration_date::date)
ORDER BY kuu;
