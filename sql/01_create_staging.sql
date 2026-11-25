-- Staging table: one column per CSV column, all text, no cleaning.
CREATE DATABASE IF NOT EXISTS cfpb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cfpb;

DROP TABLE IF EXISTS complaints_raw;
CREATE TABLE complaints_raw (
    date_received                VARCHAR(20),
    product                      VARCHAR(100),
    sub_product                  VARCHAR(100),
    issue                        VARCHAR(150),
    sub_issue                    VARCHAR(250),
    company_public_response      VARCHAR(250),
    company                      VARCHAR(150),
    state                        VARCHAR(50),
    zip_code                     VARCHAR(20),
    tags                         VARCHAR(50),
    submitted_via                VARCHAR(30),
    date_sent_to_company         VARCHAR(20),
    company_response_to_consumer VARCHAR(60),
    timely_response              VARCHAR(10),
    complaint_id                 VARCHAR(20)
) ENGINE=InnoDB;
