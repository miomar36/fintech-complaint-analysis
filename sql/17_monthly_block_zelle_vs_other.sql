-- Monthly complaint volume: Block + Zelle vs all other companies.
USE cfpb;

SELECT
    DATE_FORMAT(date_received, '%Y-%m') AS month,
    SUM(company_clean IN ('Block', 'Early Warning (Zelle)')) AS block_zelle,
    SUM(company_clean NOT IN ('Block', 'Early Warning (Zelle)')) AS all_other,
    COUNT(*) AS total
FROM fintech_clean
GROUP BY month
ORDER BY month;
