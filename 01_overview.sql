-- ============================================================
-- UPI TRANSACTIONS — OVERVIEW & VOLUME QUERIES
-- Table: upi_transactions
-- ============================================================


-- 1. High-level snapshot of the dataset
SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT sender_bank) AS unique_banks,
    ROUND(AVG(amount_inr), 2) AS avg_amount,
    MIN(amount_inr) AS min_amount,
    MAX(amount_inr) AS max_amount,
    SUM(amount_inr) AS total_volume_inr,
    SUM(CASE WHEN transaction_status = 'SUCCESS' THEN 1 ELSE 0 END) AS successful,
    SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(100.0 * SUM(CASE WHEN fraud_flag = 1 THEN 1 ELSE 0 END) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions;


-- 2. Volume and value split by transaction type
SELECT
    transaction_type,
    COUNT(*) AS txn_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_total,
    SUM(amount_inr) AS total_amount,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM upi_transactions
GROUP BY transaction_type
ORDER BY txn_count DESC;


-- 3. Month-over-month transaction volume and value
-- SQLite syntax; replace STRFTIME with DATE_FORMAT() for MySQL or FORMAT_DATE() for BigQuery
SELECT
    STRFTIME('%Y-%m', timestamp) AS month,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM upi_transactions
GROUP BY month
ORDER BY month;
