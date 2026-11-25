-- PayPal relief rate on closed complaints by quarter (through Oct 2026).
USE cfpb;

SELECT
    CONCAT(YEAR(date_received), '-Q', QUARTER(date_received)) AS quarter,
    COUNT(*) AS closed_complaints,
    ROUND(100 * SUM(company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief')) / COUNT(*), 1) AS relief_pct
FROM fintech_clean
WHERE company_clean = 'PayPal'
  AND date_received < '2026-11-01'
  AND company_response_to_consumer IN
    ('Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief')
GROUP BY quarter
ORDER BY quarter;
