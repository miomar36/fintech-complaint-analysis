-- Profile complaints_raw: row counts, columns, date range, latest month and top companies and products.
USE cfpb;

-- Row counts
SELECT COUNT(*) AS total_rows FROM complaints_raw;
SELECT LEFT(date_received, 4) AS yr, COUNT(*) AS n
FROM complaints_raw GROUP BY yr ORDER BY yr;

-- Columns and raw date format
SHOW COLUMNS FROM complaints_raw;
SELECT date_received FROM complaints_raw LIMIT 3;
SELECT MIN(CHAR_LENGTH(date_received)) AS min_len, MAX(CHAR_LENGTH(date_received)) AS max_len,
       SUM(date_received NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') AS non_iso
FROM complaints_raw;

-- Date range
SELECT MIN(date_received) AS min_date, MAX(date_received) AS max_date FROM complaints_raw;

-- Latest month vs previous month, daily average
WITH mx AS (SELECT STR_TO_DATE(MAX(date_received), '%Y-%m-%d') AS d FROM complaints_raw),
m AS (
  SELECT LEFT(date_received, 7) AS ym, COUNT(*) AS n,
         COUNT(DISTINCT date_received) AS days_with_data
  FROM complaints_raw GROUP BY ym
)
SELECT m.ym, m.n, m.days_with_data, ROUND(m.n / m.days_with_data, 1) AS avg_per_day_with_data,
       ROUND(m.n / DAY(LAST_DAY(STR_TO_DATE(CONCAT(m.ym, '-01'), '%Y-%m-%d'))), 1) AS avg_per_calendar_day
FROM m ORDER BY m.ym DESC LIMIT 3;
SELECT MAX(date_received) AS max_date, DAY(STR_TO_DATE(MAX(date_received), '%Y-%m-%d')) AS day_of_month FROM complaints_raw;

-- Top 30 companies with each one's top product
WITH comp AS (
  SELECT company, COUNT(*) AS n FROM complaints_raw GROUP BY company ORDER BY n DESC LIMIT 30
),
cp AS (
  SELECT r.company, r.product, COUNT(*) AS pn,
         ROW_NUMBER() OVER (PARTITION BY r.company ORDER BY COUNT(*) DESC) AS rk
  FROM complaints_raw r JOIN comp c ON c.company = r.company
  GROUP BY r.company, r.product
)
SELECT c.company, c.n AS complaints, cp.product AS top_product, cp.pn AS top_product_n
FROM comp c JOIN cp ON cp.company = c.company AND cp.rk = 1
ORDER BY c.n DESC;

-- Complaints by product
SELECT product, COUNT(*) AS n FROM complaints_raw GROUP BY product ORDER BY n DESC;
