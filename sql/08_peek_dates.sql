-- Peek at raw date formats in fintech_core.
USE cfpb;

SELECT date_received, date_sent_to_company, product, company
FROM fintech_core
LIMIT 10;
