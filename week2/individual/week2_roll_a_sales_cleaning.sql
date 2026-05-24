-- ============================================================
-- UrbanStyle | Week 2 | Roll A: Sales Data Cleaner
-- Autor: Vladimir G | Tabel: sales
-- ============================================================


-- Samm 1. Loo test koopia
CREATE TABLE sales_test AS SELECT * FROM sales;

-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test;
-- Tulemus: 15 234 rida


-- Samm 2. Leia duplikaadid — millised sale_id väärtused korduvad?
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
-- Tulemus: 4 013 duplikaatset sale_id


-- Samm 3. Loe kokku duplikaatsete ridade arv
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM sales_test
    GROUP BY sale_id
);
-- Tulemus: 5 116 rida on duplikaadid
-- NB: Supabase'is kasuta ctid asemel (tabelil puudub eraldi id veerg)


-- Samm 4. Leia NULL väärtused kriitilistes väljades
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL)   AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL)  AS null_total_price
FROM sales_test;
-- Tulemus:
--   null_customer_id → 1 487  (külalisostud — äriloogika, mitte viga)
--   null_sale_date   → 0
--   null_total_price → 0


-- Samm 5. Kontrolli tuleviku kuupäevi
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;
-- Tulemus: 5 tuleviku kuupäeva — andmesisestuse vead


-- Samm 6. Puhastamisraport
-- ┌─────────────────────┬──────────┬─────────────────────────────────────────┐
-- │ Kategooria          │ Probleeme│ Kirjeldus                               │
-- ├─────────────────────┼──────────┼─────────────────────────────────────────┤
-- │ Duplikaadid         │ 5 116    │ Korduvad read sama sale_id-ga           │
-- │ NULL customer_id    │ 1 487    │ Külalisostud — kehtiv äriloogika        │
-- │ NULL sale_date      │ 0        │ Kõik kuupäevad on olemas                │
-- │ NULL total_price    │ 0        │ Kõik summad on olemas                   │
-- │ Tuleviku kuupäevad  │ 5        │ Kuupäev > tänane — andmesisestuse viga  │
-- ├─────────────────────┼──────────┼─────────────────────────────────────────┤
-- │ KOKKU probleeme     │ 5 121    │                                         │
-- └─────────────────────┴──────────┴─────────────────────────────────────────┘
-- SOOVITUS: Esimene prioriteet — duplikaatide kustutamine (5 116 rida).
-- Need moonutavad kõiki müüginäitajaid kõige rohkem.


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================

-- Kustuta duplikaadid (jäta alles esimene rida iga sale_id kohta)
DELETE FROM sales_test
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM sales_test
    GROUP BY sale_id
);

-- NULL customer_id — külalisostud, mitte viga
-- Analüüsis kasuta COALESCE ajutise sildiga:
SELECT COALESCE(customer_id::text, 'külalisost') AS customer_id_puhas
FROM sales_test
LIMIT 10;

-- Paranda tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

-- Kontrolli tulemust (enne: 15 234, pärast: ~10 118)
SELECT COUNT(*) AS ridu_parast FROM sales_test;
