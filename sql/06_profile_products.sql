-- Profile complaint counts by product in fintech_complaints.
USE cfpb;

SELECT product, COUNT(*) AS complaints
FROM fintech_complaints
GROUP BY product
ORDER BY complaints DESC;
