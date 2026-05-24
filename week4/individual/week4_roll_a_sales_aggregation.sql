-- ============================================================
-- UrbanStyle | Week 4 | Roll A: Müügi koondandmed
-- Autor: Vladimir G | Tabelid: sales, products
-- ============================================================


-- 1. Müük kuude kaupa (2024)
SELECT
    DATE_TRUNC('month', sale_date::date)  AS kuu,
    COUNT(sale_id)                         AS tellimuste_arv,
    ROUND(SUM(total_price)::numeric, 2)    AS kogukäive,
    ROUND(AVG(total_price)::numeric, 2)    AS keskmine_tellimus
FROM sales
WHERE sale_date >= '2024-01-01'
  AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date::date)
ORDER BY kuu;
-- Tulemus (2024):
--   Jaanuar:   482 tellimust |  124 091 € | avg 257 €
--   Veebruar:  504 tellimust |  138 401 € | avg 275 €
--   Märts:     618 tellimust |  169 518 € | avg 274 €
--   Aprill:    600 tellimust |  163 292 € | avg 272 €
--   Mai:       606 tellimust |  169 006 € | avg 279 €
--   Juuni:     770 tellimust |  220 497 € | avg 286 €
--   Juuli:     774 tellimust |  227 908 € | avg 294 €
--   August:    749 tellimust |  209 726 € | avg 280 €
--   September: 587 tellimust |  157 702 € | avg 269 €
--   Oktoober:  568 tellimust |  188 405 € | avg 332 €
--   November:  582 tellimust |  161 234 € | avg 277 €
--   Detsember: 818 tellimust |  260 334 € | avg 318 €
-- Parim kuu: DETSEMBER (260 334 €) | Halvim: JAANUAR (124 091 €)


-- 2. Müük kategooriate kaupa (HAVING filtriga)
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)           AS tooteid,
    COUNT(s.sale_id)                        AS müüke,
    ROUND(SUM(s.total_price)::numeric, 2)   AS kogukäive,
    ROUND(AVG(s.total_price)::numeric, 2)   AS keskmine_müük
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.total_price) > 500000
ORDER BY kogukäive DESC;
-- Tulemus (HAVING > 500 000 €):
--   jalanõusid:    71 toodet | 3 067 müüki | 1 171 288 €
--   meeste_riided: 81 toodet | 3 401 müüki | 1 131 049 €
--   naiste_riided: 68 toodet | 3 030 müüki | 1 025 489 €
--   aksessuaarid:  62 toodet | 2 663 müüki |   586 267 €
-- NB: laste_riided (460 138 €) jääb HAVING filtrist välja


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 3. Kuised trendid CTE + LAG window function
WITH kuu_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date::date) AS kuu,
        ROUND(SUM(total_price)::numeric, 2)  AS käive
    FROM sales
    WHERE sale_date >= '2024-01-01'
      AND sale_date < '2025-01-01'
    GROUP BY DATE_TRUNC('month', sale_date::date)
)
SELECT
    kuu,
    käive,
    LAG(käive) OVER (ORDER BY kuu)                              AS eelmine_kuu,
    ROUND((käive - LAG(käive) OVER (ORDER BY kuu))::numeric, 2) AS muutus,
    ROUND(
        (käive - LAG(käive) OVER (ORDER BY kuu))
        / LAG(käive) OVER (ORDER BY kuu) * 100, 1
    )                                                            AS kasvu_protsent
FROM kuu_myyk
ORDER BY kuu;
-- Suurim kasv:   Detsember vs November: +99 100 € (+61.5%) — jõuluhooaeg
-- Suurim langus: September vs Juuli:    -52 024 € (-24.8%) — suvehooaja lõpp
-- Trend: selge hooajalisus — suvi (juuni-juuli) ja detsember on tipud
-- KOKKUVÕTE KRISTILE:
-- 2024. aasta kogu käive oli ~2 190 113 €. Parim kuu oli detsember (260 334 €,
-- +61.5% novembrist). Nõrgim kuu jaanuar (124 091 €). Hooajalisus on selge:
-- kaks tippu — suvi (juuni-juuli) ja jõulud. Anna peaks planeerima laovaru
-- ja turunduseelarve nende tippude jaoks juba veebruaris.
