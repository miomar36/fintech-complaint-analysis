-- Investigate the January 2025 spike by company.
USE cfpb;

SELECT company_clean, COUNT(*) AS complaints
FROM fintech_clean
WHERE date_received >= '2025-01-01'
  AND date_received < '2025-02-01'
GROUP BY company_clean
ORDER BY complaints DESC;
