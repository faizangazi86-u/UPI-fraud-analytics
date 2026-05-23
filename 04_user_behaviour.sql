-- ============================================================
-- UPI TRANSACTIONS — USER BEHAVIOUR QUERIES
-- Table: upi_transactions
-- ============================================================


-- 1. Average spend and category preference by sender age group
SELECT
    sender_age_group,
    merchant_category,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount_inr), 2) AS avg_spend
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_age_group, merchant_category
ORDER BY sender_age_group, txn_count DESC;


-- 2. Peak hours and days heatmap data (day × hour)
SELECT
    day_of_week,
    hour_of_day,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount
FROM upi_transactions
GROUP BY day_of_week, hour_of_day
ORDER BY txn_count DESC;


-- 3. Device type vs network type usage breakdown
SELECT
    device_type,
    network_type,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount_inr), 2) AS avg_amount,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY device_type, network_type
ORDER BY txn_count DESC;


-- 4. Weekend vs weekday behaviour by age group
SELECT
    sender_age_group,
    CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    COUNT(*) AS txn_count,
    ROUND(AVG(amount_inr), 2) AS avg_amount,
    SUM(amount_inr) AS total_amount
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_age_group, day_type
ORDER BY sender_age_group, day_type;


-- 5. P2P vs P2M preference by age group
SELECT
    sender_age_group,
    transaction_type,
    COUNT(*) AS txn_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY sender_age_group), 2) AS pct_within_age
FROM upi_transactions
GROUP BY sender_age_group, transaction_type
ORDER BY sender_age_group, txn_count DESC;
