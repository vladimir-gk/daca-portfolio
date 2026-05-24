-- ============================================================
-- UrbanStyle | Week 2 | Roll D: Data Quality Analyst
-- Autor: Vladimir G | Tabelid: sales, customers, products
-- ============================================================


-- Samm 1. Orbid müügid — customer_id, mida pole customers tabelis
SELECT COUNT(*) AS orb_klient
FROM sales s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL
  AND s.customer_id IS NOT NULL;
-- Tulemus: 0 — kõik viited on kehtivad
-- NB: 1 487 NULL customer_id on külalisostud — need on eraldi kategooria


-- Samm 2. Orbid müügid — product_id, mida pole products tabelis
SELECT COUNT(*) AS orb_toode
FROM sales s
LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL
  AND s.product_id IS NOT NULL;
-- Tulemus: 0 — kõik tooteviited on kehtivad


-- Samm 3. Hindade kooskõla — müügihind vs tootehind × kogus
SELECT
    s.sale_id,
    s.total_price,
    p.retail_price                        AS tootehind,
    s.quantity,
    ROUND((p.retail_price * s.quantity)::numeric, 2) AS oodatud_hind,
    ROUND((s.total_price - (p.retail_price * s.quantity))::numeric, 2) AS erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC
LIMIT 20;
-- Tulemus: 664 müügil ei klapi hind tootehinnaga (> 1 EUR erinevus)
-- Põhjused: allahindlused, tagastused (negatiivsed), hulgihinnad, andmevead


-- Samm 4. Vaimkliendid — kliendid, kes pole kunagi ostnud
SELECT COUNT(*) AS vaimkliendid
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;
-- Tulemus: 592 klienti pole kunagi ostnud (~18.8% kõigist klientidest)


-- Samm 5. Vaimtooted — tooted, mida pole kunagi müüdud
SELECT COUNT(*) AS vaimtooted
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.product_id IS NULL;
-- Tulemus: 12 toodet pole kunagi müüdud


-- Samm 6. Ristvalideerimise raport
-- ┌──────────────────────┬──────────┬──────────────────────────────────────────────┐
-- │ Kategooria           │ Probleeme│ Kirjeldus                                    │
-- ├──────────────────────┼──────────┼──────────────────────────────────────────────┤
-- │ Orbid kliendid       │ 0        │ Kõik customer_id viited on kehtivad          │
-- │ Orbid tooted         │ 0        │ Kõik product_id viited on kehtivad           │
-- │ Hinna ebakõlad       │ 664      │ Müügihind ≠ retail_price × quantity          │
-- │ Vaimkliendid         │ 592      │ Registreeritud, aga pole kunagi ostnud       │
-- │ Vaimtooted           │ 12       │ Kataloogis olemas, aga müümata               │
-- ├──────────────────────┼──────────┼──────────────────────────────────────────────┤
-- │ KOKKU probleeme      │ 1 268    │                                              │
-- └──────────────────────┴──────────┴──────────────────────────────────────────────┘
-- SOOVITUS: Kõige kriitilisem — 664 hinna ebakõla.
-- Need mõjutavad otseselt tulude aruandlust ja marginaalianalüüsi.
-- 592 vaimklienti on turunduse prioriteet (re-engagement kampaania).


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================

-- Millised tooted on suurimate hinnaerinevustega?
SELECT
    p.product_name,
    p.category,
    p.retail_price                                              AS list_hind,
    ROUND(AVG(s.total_price / NULLIF(s.quantity, 0))::numeric, 2) AS kesk_muugihind,
    ROUND((p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0)))::numeric, 2) AS erinevus
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.retail_price
HAVING ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) > 5
ORDER BY ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) DESC
LIMIT 10;
-- Mõtle: hinnaerinevused võivad viidata allahindlustele, hulgiostudele või andmevigadele
