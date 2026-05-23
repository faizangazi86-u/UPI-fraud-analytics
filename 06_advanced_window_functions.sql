-- ============================================================
-- UPI TRANSACTIONS — ADVANCED & WINDOW FUNCTION QUERIES
-- Table: upi_transactions
-- Note: Requires a database that supports window functions
--       (PostgreSQL, MySQL 8+, SQLite 3.25+, BigQuery, Snowflake)
-- ============================================================


-- 1. Cumulative transaction volume over time (running total)
SELECT
    month,
    monthly_amount,
    SUM(monthly_amount) OVER (ORDER BY month) AS running_total
FROM (
    SELECT
        STRFTIME('%Y-%m', timestamp) AS month,
        SUM(amount_inr) AS monthly_amount
    FROM upi_transactions
    WHERE transaction_status = 'SUCCESS'
    GROUP BY month
) AS monthly
ORDER BY month;


-- 2. Most popular merchant category in each state (RANK)
SELECT sender_state, merchant_category, txn_count
FROM (
    SELECT
        sender_state,
        merchant_category,
        COUNT(*) AS txn_count,
        RANK() OVER (PARTITION BY sender_state ORDER BY COUNT(*) DESC) AS rnk
    FROM upi_transactions
    WHERE transaction_status = 'SUCCESS'
    GROUP BY sender_state, merchant_category
) AS ranked
WHERE rnk = 1
ORDER BY sender_state;


-- 3. Fraud risk score per user segment (age × device × network)
SELECT
    sender_age_group,
    device_type,
    network_type,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct,
    ROUND(AVG(amount_inr), 2) AS avg_amount
FROM upi_transactions
GROUP BY sender_age_group, device_type, network_type
HAVING COUNT(*) > 100
ORDER BY fraud_rate_pct DESC;


-- 4. Month-over-month growth rate in transaction count
SELECT
    month,
    txn_count,
    LAG(txn_count) OVER (ORDER BY month) AS prev_month_count,
    ROUND(100.0 * (txn_count - LAG(txn_count) OVER (ORDER BY month))
          / LAG(txn_count) OVER (ORDER BY month), 2) AS mom_growth_pct
FROM (
    SELECT
        STRFTIME('%Y-%m', timestamp) AS month,
        COUNT(*) AS txn_count
    FROM upi_transactions
    GROUP BY month
) AS monthly
ORDER BY month;


-- 5. Top 3 banks by transaction volume per state (DENSE_RANK)
SELECT sender_state, sender_bank, total_amount, rnk
FROM (
    SELECT
        sender_state,
        sender_bank,
        SUM(amount_inr) AS total_amount,
        DENSE_RANK() OVER (PARTITION BY sender_state ORDER BY SUM(amount_inr) DESC) AS rnk
    FROM upi_transactions
    WHERE transaction_status = 'SUCCESS'
    GROUP BY sender_state, sender_bank
) AS ranked
WHERE rnk <= 3
ORDER BY sender_state, rnk;


-- 6. 7-day rolling average of daily transaction count
SELECT
    txn_date,
    daily_count,
    ROUND(AVG(daily_count) OVER (
        ORDER BY txn_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 1) AS rolling_7d_avg
FROM (
    SELECT
        DATE(timestamp) AS txn_date,
        COUNT(*) AS daily_count
    FROM upi_transactions
    GROUP BY txn_date
) AS daily
ORDER BY txn_date;
