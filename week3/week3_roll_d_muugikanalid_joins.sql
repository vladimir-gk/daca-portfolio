-- ============================================================
-- UrbanStyle | Week 3 | Roll D: Müügikanalid (INNER JOIN, 3 tabelit)
-- Autor: Vladimir G | Tabelid: sales, customers, products
-- ============================================================


-- 1. Unikaalsed müügikanalid
SELECT DISTINCT channel
FROM sales
ORDER BY channel;
-- Tulemus: 2 kanalit → 'online', 'pood'


-- 2. Kanalite põhiülevaade
SELECT
    s.channel                                          AS müügikanal,
    COUNT(DISTINCT s.customer_id)                      AS kliente,
    COUNT(s.sale_id)                                   AS oste,
    ROUND(SUM(s.total_price)::numeric, 2)              AS kogumüük
FROM sales s
GROUP BY s.channel
ORDER BY kogumüük DESC;
-- Tulemus:
--   pood:   2 287 klienti | 10 030 ostu | 2 847 956 €
--   online: 1 730 klienti |  5 204 ostu | 1 526 276 €


-- 3. Klientide profiil kanali ja linna kaupa
SELECT
    s.channel                                          AS müügikanal,
    c.city                                             AS linn,
    COUNT(DISTINCT c.customer_id)                      AS kliente,
    ROUND(SUM(s.total_price)::numeric, 2)              AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel, c.city
ORDER BY müügikanal, kogumüük DESC;
-- TOP kombinatsioonid:
--   pood   x Tallinn: 875 klienti | 972 916 €
--   online x Tallinn: 650 klienti | 491 245 €
--   pood   x Tartu:   441 klienti | 474 756 €


-- 4. Kolme tabeli JOIN: müügikanalid × tootekategooriad
SELECT
    s.channel                                              AS müügikanal,
    p.category                                             AS tootekategooria,
    COUNT(DISTINCT c.customer_id)                          AS kliente,
    COUNT(s.sale_id)                                       AS oste,
    ROUND(SUM(s.total_price)::numeric, 2)                  AS kogumüük,
    ROUND(AVG(s.total_price)::numeric, 2)                  AS keskmine_ost
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p  ON s.product_id  = p.product_id
GROUP BY s.channel, p.category
ORDER BY müügikanal, kogumüük DESC;
-- LEID: online kanal müüb jalanõusid kõrgema keskmise hinnaga (403 €)
-- kui pood (366 €) — online ostjad on nõus rohkem maksma


-- 5. Kõige efektiivsem kanal (müük per klient)
SELECT
    s.channel                                              AS müügikanal,
    COUNT(DISTINCT s.customer_id)                          AS kliente,
    ROUND(SUM(s.total_price)::numeric, 2)                  AS kogumüük,
    ROUND((SUM(s.total_price) /
           NULLIF(COUNT(DISTINCT s.customer_id), 0))::numeric, 2) AS müük_per_klient
FROM sales s
GROUP BY s.channel
ORDER BY müük_per_klient DESC;
-- Tulemus:
--   pood:   müük per klient → 1 245 €
--   online: müük per klient →   882 €
-- LEID: füüsiline pood on per-klient efektiivsem (+41%)


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 6. Kaupluste võrdlus kanalite kaupa
SELECT
    COALESCE(s.store_location, 'Online') AS kauplus,
    s.channel                             AS müügikanal,
    COUNT(s.sale_id)                      AS oste,
    ROUND(SUM(s.total_price)::numeric, 2) AS kogumüük,
    ROUND(AVG(s.total_price)::numeric, 2) AS keskmine_ost
FROM sales s
GROUP BY s.store_location, s.channel
ORDER BY kauplus, kogumüük DESC;
-- ÄRILINE JÄRELDUS:
-- Pood domineerib nii müügi mahult (65.8%) kui efektiivsuselt (1 245 € per klient vs 882 €).
-- Online kanal näitab kõrgemat keskmist hinda jalanõudes (403 € vs 366 €) —
-- online ostjad on hinnatundlikumad, aga valivad kallimaid tooteid.
-- Soovitus Annale: suunata online turunduseelarve jalanõude kategooriasse,
-- kus online kanal on juba tugevam. Tallinn on mõlemas kanalis domineeriv —
-- Tartu ja Pärnu online-potentsiaal on alakasutatud.
