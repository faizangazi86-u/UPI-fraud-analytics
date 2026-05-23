-- ============================================================
-- UPI TRANSACTIONS — FRAUD ANALYSIS QUERIES
-- Table: upi_transactions
-- ============================================================


-- 1. Which sender banks have the highest fraud rate?
SELECT
    sender_bank,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY sender_bank
ORDER BY fraud_rate_pct DESC;


-- 2. Are frauds more common at certain hours?
SELECT
    hour_of_day,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- 3. Do high-value transactions have more fraud?
SELECT
    CASE
        WHEN amount_inr BETWEEN 0 AND 500    THEN '0–500'
        WHEN amount_inr BETWEEN 501 AND 2000  THEN '501–2000'
        WHEN amount_inr BETWEEN 2001 AND 10000 THEN '2001–10000'
        ELSE '10000+'
    END AS amount_bucket,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY amount_bucket
ORDER BY MIN(amount_inr);


-- 4. Fraud rate by merchant category
SELECT
    merchant_category,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY merchant_category
ORDER BY fraud_rate_pct DESC;


-- 5. Fraud rate on weekends vs weekdays
SELECT
    CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY day_type;
