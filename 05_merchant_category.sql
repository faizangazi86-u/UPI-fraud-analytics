-- ============================================================
-- UPI TRANSACTIONS — MERCHANT CATEGORY QUERIES
-- Table: upi_transactions
-- ============================================================


-- 1. Revenue, volume and failure rate per merchant category
SELECT
    merchant_category,
    COUNT(*) AS total_txns,
    SUM(CASE WHEN transaction_status = 'SUCCESS' THEN amount_inr ELSE 0 END) AS successful_volume,
    ROUND(AVG(amount_inr), 2) AS avg_txn_size,
    ROUND(100.0 * SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct
FROM upi_transactions
GROUP BY merchant_category
ORDER BY successful_volume DESC;


-- 2. Do categories behave differently on weekends vs weekdays?
SELECT
    merchant_category,
    CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY merchant_category, day_type
ORDER BY merchant_category, day_type;


-- 3. Top merchant category by state
SELECT
    sender_state,
    merchant_category,
    COUNT(*) AS txn_count
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_state, merchant_category
ORDER BY sender_state, txn_count DESC;


-- 4. Hourly spend pattern by merchant category
SELECT
    merchant_category,
    hour_of_day,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY merchant_category, hour_of_day
ORDER BY merchant_category, hour_of_day;


-- 5. Category share of total successful volume
SELECT
    merchant_category,
    SUM(amount_inr) AS category_volume,
    ROUND(100.0 * SUM(amount_inr) / SUM(SUM(amount_inr)) OVER(), 2) AS volume_share_pct
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY merchant_category
ORDER BY category_volume DESC;
