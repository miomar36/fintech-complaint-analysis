-- Count complaints per company name in the raw staging table.
USE cfpb;
DROP TABLE IF EXISTS company_counts;
CREATE TABLE company_counts AS
SELECT company, COUNT(*) AS complaints
FROM complaints_raw
GROUP BY company;
