-- Monthly complaint volume in fintech_clean.
USE cfpb;

SELECT
    DATE_FORMAT(date_received, '%Y-%m') AS month,
    COUNT(*) AS complaints
FROM fintech_clean
GROUP BY month
ORDER BY month;
