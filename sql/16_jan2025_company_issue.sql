-- Top company/issue combinations in the January 2025 complaint spike.
USE cfpb;

SELECT company_clean, issue, COUNT(*) AS complaints
FROM fintech_clean
WHERE date_received >= '2025-01-01'
  AND date_received < '2025-02-01'
GROUP BY company_clean, issue
ORDER BY complaints DESC
LIMIT 8;
