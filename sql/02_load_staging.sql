USE cfpb;

TRUNCATE TABLE complaints_raw;

LOAD DATA LOCAL INFILE 'C:/data/cfpb/processed/complaints_2024plus.csv'
INTO TABLE complaints_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SHOW WARNINGS;
SELECT COUNT(*) AS rows_loaded FROM complaints_raw;
