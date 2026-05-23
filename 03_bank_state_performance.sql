-- ============================================================
-- UPI TRANSACTIONS — BANK & STATE PERFORMANCE QUERIES
-- Table: upi_transactions
-- ============================================================


-- 1. Top sender→receiver bank pairs by transaction volume
SELECT
    sender_bank,
    receiver_bank,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_bank, receiver_bank
ORDER BY txn_count DESC
LIMIT 20;


-- 2. Which banks have the highest failure rate?
SELECT
    sender_bank,
    COUNT(*) AS total,
    SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) AS failed,
    ROUND(100.0 * SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct
FROM upi_transactions
GROUP BY sender_bank
ORDER BY failure_rate_pct DESC;


-- 3. State-wise transaction volume and average ticket size
SELECT
    sender_state,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount,
    ROUND(AVG(amount_inr), 2) AS avg_ticket,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS share_pct
FROM upi_transactions
GROUP BY sender_state
ORDER BY total_amount DESC;


-- 4. Bank performance scorecard (volume + failure + fraud)
SELECT
    sender_bank,
    COUNT(*) AS total_txns,
    SUM(amount_inr) AS total_volume,
    ROUND(AVG(amount_inr), 2) AS avg_txn,
    ROUND(100.0 * SUM(CASE WHEN transaction_status = 'FAILED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY sender_bank
ORDER BY total_volume DESC;


-- 5. State × bank breakdown
SELECT
    sender_state,
    sender_bank,
    COUNT(*) AS txn_count,
    SUM(amount_inr) AS total_amount
FROM upi_transactions
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_state, sender_bank
ORDER BY sender_state, total_amount DESC;
