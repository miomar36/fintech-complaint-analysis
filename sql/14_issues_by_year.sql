-- Yearly complaint counts and share of year for five selected issues.
USE cfpb;

WITH yearly AS (
    SELECT
        YEAR(date_received) AS yr,
        issue,
        COUNT(*) AS complaints,
        ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY YEAR(date_received)), 1) AS pct_of_year
    FROM fintech_clean
    GROUP BY yr, issue
)
SELECT yr, issue, complaints, pct_of_year
FROM yearly
WHERE issue IN (
    'Other transaction problem',
    'Managing an account',
    'Fraud or scam',
    'Unauthorized transactions or other transaction problem',
    'Problem with a lender or other company charging your account'
)
ORDER BY issue, yr;
