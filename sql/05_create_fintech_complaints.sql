-- Create fintech_complaints: raw rows for the selected fintech company names.
USE cfpb;

DROP TABLE IF EXISTS fintech_complaints;

CREATE TABLE fintech_complaints AS
SELECT *
FROM complaints_raw
WHERE company IN (
    'Block, Inc.',
    'Early Warning Services, LLC',
    'Paypal Holdings, Inc',
    'Chime Financial Inc',
    'Chime Inc.',
    'Affirm Holdings, Inc',
    'SOFI TECHNOLOGIES, INC.',
    'ROBINHOOD MARKETS INC.',
    'Coinbase, Inc.',
    'Upstart Holdings, Inc.',
    'Klarna AB',
    'MoneyLion Inc.',
    'TransferWise Ltd'
);
