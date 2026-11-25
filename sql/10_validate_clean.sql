-- Validate fintech_clean: date range, null counts and row count.
USE cfpb;

SELECT
    MIN(date_received) AS first_date,
    MAX(date_received) AS last_date,
    SUM(date_received IS NULL) AS null_dates,
    SUM(company_clean IS NULL) AS null_companies,
    COUNT(*) AS total_rows
FROM fintech_clean;
