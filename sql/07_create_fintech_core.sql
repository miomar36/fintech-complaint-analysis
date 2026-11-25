-- Create fintech_core: fintech complaints limited to the 6 core products.
USE cfpb;

DROP TABLE IF EXISTS fintech_core;

CREATE TABLE fintech_core AS
SELECT *
FROM fintech_complaints
WHERE product IN (
    'Money transfer, virtual currency, or money service',
    'Checking or savings account',
    'Debt collection',
    'Payday loan, title loan, personal loan, or advance loan',
    'Credit card',
    'Prepaid card'
);
