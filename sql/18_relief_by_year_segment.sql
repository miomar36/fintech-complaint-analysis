-- Relief rate on closed complaints by year, Block+Zelle vs other 10 companies.
USE cfpb;

SELECT
    YEAR(date_received) AS yr,
    CASE WHEN company_clean IN ('Block', 'Early Warning (Zelle)')
         THEN 'Block+Zelle' ELSE 'Other 10' END AS segment,
    COUNT(*) AS closed_complaints,
    SUM(company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief')) AS got_relief,
    ROUND(100 * SUM(company_response_to_consumer IN
        ('Closed with monetary relief', 'Closed with non-monetary relief')) / COUNT(*), 1) AS relief_pct
FROM fintech_clean
WHERE company_response_to_consumer IN
    ('Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief')
GROUP BY yr, segment
ORDER BY segment, yr;
