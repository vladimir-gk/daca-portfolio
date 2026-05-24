-- ============================================================
-- UrbanStyle | Week 4 | Roll D: Turunduskampaaniate ROI
-- Autor: Vladimir G | Tabelid: sales, customers, web_logs
-- ============================================================
-- NB: web_logs sisaldab 50 000 rida, 18.8% anonüümsete külastajatega
--     (customer_id IS NULL) — need on tundmatud kasutajad, mitte viga.
-- NB: source veerg sisaldab kirjaviisi ebajärjepidevusi:
--     'google_organic', 'google organic', 'Google Organic' → ühtlustatakse LOWER(TRIM())


-- 0. Kontrolli web_logs tabelit
SELECT COUNT(*) AS kokku_ridu FROM web_logs;
-- Tulemus: 50 000 rida

SELECT source, COUNT(*) AS arv
FROM web_logs
GROUP BY source
ORDER BY arv DESC;
-- LEID: 'google_organic', 'google organic', 'Google Organic' on sama kanal
-- → vajalik normaliseerimine LOWER(TRIM(source))


-- 1. Turunduskanalite koondandmed (LEFT JOIN web_logs)
SELECT
    COALESCE(LOWER(TRIM(w.source)), 'tundmatu') AS turunduskanal,
    COUNT(DISTINCT c.customer_id)                AS kliente,
    COUNT(DISTINCT s.sale_id)                    AS tellimusi,
    ROUND(SUM(s.total_price)::numeric, 2)        AS kogukäive,
    ROUND(AVG(s.total_price)::numeric, 2)        AS keskmine_tellimus
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN web_logs w ON c.customer_id = w.customer_id
GROUP BY LOWER(TRIM(w.source))
ORDER BY kogukäive DESC;
-- Tulemus (TOP kanalid, normaliseeritud):
--   google_organic: 743 klienti | 4 061 tellimust | 1 183 693 € | avg 291 €
--   direct:         460 klienti | 2 228 tellimust |   630 293 € | avg 283 €
--   facebook_ads:   351 klienti | 2 124 tellimust |   600 277 € | avg 283 €
--   email_campaign: 256 klienti | 1 444 tellimust |   431 696 € | avg 299 €
--   instagram:      271 klienti | 1 292 tellimust |   359 929 € | avg 279 €
--   google_ads:     187 klienti | 1 109 tellimust |   331 578 € | avg 299 €
--   tiktok:         107 klienti |   523 tellimust |   139 856 € | avg 267 €


-- 2. Kampaaniate kuised trendid (GROUP BY kanal + kuu)
SELECT
    LOWER(TRIM(w.source))                         AS turunduskanal,
    DATE_TRUNC('month', s.sale_date::date)         AS kuu,
    COUNT(DISTINCT s.customer_id)                  AS kliente,
    ROUND(SUM(s.total_price)::numeric, 2)          AS kogukäive
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
LEFT JOIN web_logs w ON c.customer_id = w.customer_id
WHERE s.sale_date >= '2024-01-01'
GROUP BY LOWER(TRIM(w.source)), DATE_TRUNC('month', s.sale_date::date)
HAVING COUNT(DISTINCT s.customer_id) > 10
ORDER BY kuu, kogukäive DESC;


-- ============================================================
-- EDASIJÕUDNUD ÜLESANDED (Advanced)
-- ============================================================


-- 3. Kanali efektiivsus CTE-ga (müük per klient)
WITH kanali_myyk AS (
    SELECT
        COALESCE(LOWER(TRIM(w.source)), 'tundmatu') AS kanal,
        ROUND(SUM(s.total_price)::numeric, 2)        AS kogukäive,
        COUNT(DISTINCT s.sale_id)                    AS tellimusi
    FROM sales s
    LEFT JOIN web_logs w ON s.customer_id = w.customer_id
    GROUP BY LOWER(TRIM(w.source))
    HAVING COUNT(DISTINCT s.sale_id) > 100
),
kanali_kliendid AS (
    SELECT
        COALESCE(LOWER(TRIM(w.source)), 'tundmatu') AS kanal,
        COUNT(DISTINCT s.customer_id)               AS kliente
    FROM sales s
    LEFT JOIN web_logs w ON s.customer_id = w.customer_id
    GROUP BY LOWER(TRIM(w.source))
)
SELECT
    m.kanal,
    m.kogukäive,
    m.tellimusi,
    k.kliente,
    ROUND((m.kogukäive / NULLIF(k.kliente, 0))::numeric, 2) AS müük_per_klient
FROM kanali_myyk m
JOIN kanali_kliendid k ON m.kanal = k.kanal
ORDER BY müük_per_klient DESC;
-- Tulemus (efektiivsus per klient):
--   google_ads:     1 773 € per klient → parim ROI väiksemate mahtudega
--   facebook_ads:   1 710 € per klient
--   email_campaign: 1 686 € per klient → kõrge efektiivsus, väike klientide arv
--   google_organic: 1 593 € per klient → suurim maht + hea efektiivsus
--   instagram:      1 328 € per klient
--   tiktok:         1 307 € per klient → madalaim efektiivsus

-- KRISTI ESITLUSE KOONDNUMBRID (5 peamist):
-- 1. Suurim kanal mahult: google_organic — 1 183 693 € käive, 743 klienti
-- 2. Parim ROI: google_ads — 1 773 € müük per klient (vs keskmine 1 541 €)
-- 3. Email kampaania: 1 686 € per klient — kõrge efektiivsus, alakasutatud kanal
-- 4. TikTok: madalaim efektiivsus (1 307 €/klient) — investeeringut ei tasusta praegu
-- 5. 18.8% veebikülastustest on anonüümsed — potentsiaalne andmepuudus konversiooni mõõtmisel
-- SOOVITUS: suurendada google_ads ja email_campaign eelarvet (parim ROI),
-- vähendada tiktok investeeringut kuni konversioon paraneb.
