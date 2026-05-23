# UPI Fraud Transaction Analytics — SQL + Power BI

> Fraud detection analysis on **250,000 UPI transactions** — identifying high-risk segments by device, network, state, merchant category, and time of day using SQL and Power BI.

![Dashboard Preview](assets/dashboard-preview.png)

---

## Business Problem

UPI processes billions of transactions monthly in India. Fraud teams need to know:
- **When** do fraud transactions peak — hour, day, weekend?
- **Where** are high-risk states and banks?
- **Who** is most vulnerable — by age group, device, network?
- **Which** merchant categories carry the most fraud risk?

This project answers all four using 250K real-pattern transactions, 6 SQL analysis modules, and a Power BI dashboard built for a fraud analyst audience.

---

## Key Findings

| Finding | Detail |
|---|---|
| 250,000 transactions analysed | ₹32.7 Cr total transaction volume |
| 480 fraud transactions detected | 0.19% fraud rate |
| ₹7.2L total fraud value | Average fraud ticket: ₹1,500 |
| Maharashtra = #1 fraud state | 71 fraud transactions |
| Karnataka = #2 fraud state | 69 fraud transactions — home state risk |
| Android = highest fraud volume | 364 of 480 fraud cases |
| 4G network = highest fraud volume | 282 of 480 fraud cases |
| Grocery = most targeted category | Highest fraud transaction count |
| Failure rate: 4.95% | 12,376 failed transactions |

---

## Dataset

| Field | Detail |
|---|---|
| Rows | 250,000 transactions |
| Columns | 17 fields |
| Key fields | Transaction Type, Merchant Category, Amount (INR), Status, Sender/Receiver Bank, Device Type, Network Type, Fraud Flag, Hour, Day, State |

---

## Tech Stack

| Tool | Usage |
|---|---|
| **SQL** | 6 analysis modules — fraud, behaviour, bank performance, merchant, window functions |
| **Power BI** | Interactive fraud dashboard, slicers, map visual |
| **Excel / CSV** | Source data |

---

## SQL Modules

| File | What It Answers |
|---|---|
| `01_overview.sql` | Total volume, success/failure split, fraud rate snapshot |
| `02_fraud_analysis.sql` | Fraud by bank, hour, amount bucket, category, weekend vs weekday |
| `03_bank_state_performance.sql` | Top bank pairs, failure rates, state-wise volume, bank scorecard |
| `04_user_behaviour.sql` | Age group spend, peak hours heatmap, device × network breakdown |
| `05_merchant_category.sql` | Revenue + failure rate per category, weekend vs weekday, hourly patterns |
| `06_advanced_window_functions.sql` | Running totals, MoM growth (LAG), 7-day rolling avg, RANK/DENSE_RANK |

---

## Sample Query — Fraud by Hour

```sql
SELECT
    hour_of_day,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY hour_of_day
ORDER BY hour_of_day;
```

---

## Sample Query — Fraud Risk Score by Segment (Window Function)

```sql
SELECT
    sender_age_group,
    device_type,
    network_type,
    COUNT(*) AS total_txns,
    SUM(fraud_flag) AS fraud_count,
    ROUND(100.0 * SUM(fraud_flag) / COUNT(*), 3) AS fraud_rate_pct
FROM upi_transactions
GROUP BY sender_age_group, device_type, network_type
HAVING COUNT(*) > 100
ORDER BY fraud_rate_pct DESC;
```

---

## Dashboard Features

- KPI cards — Total Transactions, Fraud Count, Fraud Rate %, Fraud Value
- Fraud transactions by Hour (bar chart)
- Fraud by State (India map visual)
- Fraud by Device Type
- Fraud by Network Type
- Fraud by Transaction Type (P2P / P2M / Bill Payment / Recharge)
- Fraud by Merchant Category
- Fraud by Amount Category (Low / Medium / High value)

---

## Folder Structure

```
upi-fraud-analytics/
│
├── data/
│   └── upi_transactions_processed.csv
│
├── sql/
│   ├── 01_overview.sql
│   ├── 02_fraud_analysis.sql
│   ├── 03_bank_state_performance.sql
│   ├── 04_user_behaviour.sql
│   ├── 05_merchant_category.sql
│   └── 06_advanced_window_functions.sql
│
├── dashboard/
│   └── UPI_Fraud_Dashboard.pbix
│
├── assets/
│   └── dashboard-preview.png
│
└── README.md
```

---

## How to Run SQL

Compatible with **MySQL 8+**, **PostgreSQL**, **SQLite 3.25+**, **BigQuery**, **Snowflake**.

```sql
-- Load CSV into your SQL client, then run:
-- Start with 01_overview.sql for the full dataset snapshot
-- Run 02_fraud_analysis.sql for fraud-specific deep dives
-- Run 06_advanced_window_functions.sql for window function analysis
```

---

## Open to Freelance

Need fraud monitoring dashboards or data analysis for your fintech or business?

[![Email](https://img.shields.io/badge/Email%20Me-EA4335?style=flat&logo=gmail&logoColor=white)](mailto:faizangazi86@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://linkedin.com/in/mohammed-faizan-g-069bb0325)

---

*Built by [Mohammed Faizan Gazi](https://github.com/faizangazi86-u) · Tools: SQL · Power BI · Excel*
