-- Relief rate by company, 2024-25 vs 2026 (excluding Block and Zelle).
USE cfpb;

SELECT
    company_clean,
    SUM(date_received < '2026-01-01') AS closed_2024_25,
    ROUND(100 * SUM(date_received < '2026-01-01' AND company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief'))
        / SUM(date_received < '2026-01-01'), 1) AS relief_pct_2024_25,
    SUM(date_received >= '2026-01-01') AS closed_2026,
    ROUND(100 * SUM(date_received >= '2026-01-01' AND company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief'))
        / SUM(date_received >= '2026-01-01'), 1) AS relief_pct_2026
FROM fintech_clean
WHERE company_response_to_consumer IN
    ('Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief')
  AND company_clean NOT IN ('Block', 'Early Warning (Zelle)')
GROUP BY company_clean
ORDER BY closed_2026 DESC;
