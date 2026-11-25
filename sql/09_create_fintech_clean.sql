-- Create fintech_clean: typed dates and standardized company names.
USE cfpb;

DROP TABLE IF EXISTS fintech_clean;

CREATE TABLE fintech_clean AS
SELECT
    complaint_id,
    CASE WHEN date_received = '' THEN NULL
         ELSE STR_TO_DATE(date_received, '%Y-%m-%d') END AS date_received,
    CASE WHEN date_sent_to_company = '' THEN NULL
         ELSE STR_TO_DATE(date_sent_to_company, '%Y-%m-%d') END AS date_sent_to_company,
    product,
    sub_product,
    issue,
    sub_issue,
    company,
    CASE
        WHEN company IN ('Chime Financial Inc', 'Chime Inc.') THEN 'Chime'
        WHEN company = 'TransferWise Ltd' THEN 'Wise'
        WHEN company = 'Block, Inc.' THEN 'Block'
        WHEN company = 'Early Warning Services, LLC' THEN 'Early Warning (Zelle)'
        WHEN company = 'Paypal Holdings, Inc' THEN 'PayPal'
        WHEN company = 'Affirm Holdings, Inc' THEN 'Affirm'
        WHEN company = 'SOFI TECHNOLOGIES, INC.' THEN 'SoFi'
        WHEN company = 'ROBINHOOD MARKETS INC.' THEN 'Robinhood'
        WHEN company = 'Coinbase, Inc.' THEN 'Coinbase'
        WHEN company = 'Upstart Holdings, Inc.' THEN 'Upstart'
        WHEN company = 'Klarna AB' THEN 'Klarna'
        WHEN company = 'MoneyLion Inc.' THEN 'MoneyLion'
    END AS company_clean,
    state,
    submitted_via,
    company_response_to_consumer,
    company_public_response,
    timely_response,
    tags
FROM fintech_core;
