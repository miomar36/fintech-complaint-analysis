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
