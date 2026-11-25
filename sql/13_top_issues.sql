-- Top 15 issues overall with share of total complaints.
USE cfpb;

SELECT
    issue,
    COUNT(*) AS complaints,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM fintech_clean
GROUP BY issue
ORDER BY complaints DESC
LIMIT 15;
