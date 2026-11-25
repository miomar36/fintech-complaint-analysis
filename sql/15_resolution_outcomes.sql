-- Distribution of company responses (resolution outcomes) overall.
USE cfpb;

SELECT
    company_response_to_consumer,
    COUNT(*) AS complaints,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM fintech_clean
GROUP BY company_response_to_consumer
ORDER BY complaints DESC;
