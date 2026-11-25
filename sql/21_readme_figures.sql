-- Figures quoted in the README key findings, for the 10 companies other than Block and Zelle.
-- Periods: 2024-25 = before 2026-01-01, 2026 = 2026-01-01 onward (includes partial November 2026).
USE cfpb;

-- 1. Issue share of all complaints, 2024-25 vs 2026
SELECT
    f.issue,
    ROUND(100 * SUM(f.date_received < '2026-01-01') / MAX(tot.n_2024_25), 1) AS pct_2024_25,
    ROUND(100 * SUM(f.date_received >= '2026-01-01') / MAX(tot.n_2026), 1) AS pct_2026
FROM fintech_clean f
CROSS JOIN (
    SELECT SUM(date_received < '2026-01-01')  AS n_2024_25,
           SUM(date_received >= '2026-01-01') AS n_2026
    FROM fintech_clean
    WHERE company_clean NOT IN ('Block', 'Early Warning (Zelle)')
) tot
WHERE f.company_clean NOT IN ('Block', 'Early Warning (Zelle)')
  AND f.issue IN ('Managing an account',
                  'Unauthorized transactions or other transaction problem')
GROUP BY f.issue;

-- 2. Overall relief rate on closed complaints, 2024-25 vs 2026
SELECT
    ROUND(100 * SUM(date_received < '2026-01-01' AND company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief'))
        / SUM(date_received < '2026-01-01'), 1) AS relief_pct_2024_25,
    ROUND(100 * SUM(date_received >= '2026-01-01' AND company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief'))
        / SUM(date_received >= '2026-01-01'), 1) AS relief_pct_2026
FROM fintech_clean
WHERE company_response_to_consumer IN
    ('Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief')
  AND company_clean NOT IN ('Block', 'Early Warning (Zelle)');

-- 3. Overall relief rate on closed complaints across all 12 companies (the Power BI card, 7.5%)
SELECT
    ROUND(100 * SUM(company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief'))
        / COUNT(*), 1) AS relief_pct_all_12
FROM fintech_clean
WHERE company_response_to_consumer IN
    ('Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief');

-- 4. Rows in fintech_complaints, before the product filter (185,119)
SELECT COUNT(*) AS fintech_complaints_rows FROM fintech_complaints;

-- 5. Complaints per selected company since 2024, all products (each should be 1,000 or more).
--    Chime Inc. is merged into Chime Financial and TransferWise Ltd is Wise, as in fintech_clean.
SELECT
    CASE
        WHEN company IN ('Chime Financial Inc', 'Chime Inc.') THEN 'Chime'
        WHEN company = 'TransferWise Ltd' THEN 'Wise'
        ELSE company
    END AS company_group,
    SUM(complaints) AS complaints_since_2024
FROM company_counts
WHERE company IN (
    'Block, Inc.', 'Early Warning Services, LLC', 'Paypal Holdings, Inc',
    'Chime Financial Inc', 'Chime Inc.', 'Affirm Holdings, Inc', 'SOFI TECHNOLOGIES, INC.',
    'ROBINHOOD MARKETS INC.', 'Coinbase, Inc.', 'Upstart Holdings, Inc.', 'Klarna AB',
    'MoneyLion Inc.', 'TransferWise Ltd'
)
GROUP BY company_group
ORDER BY complaints_since_2024 DESC;
