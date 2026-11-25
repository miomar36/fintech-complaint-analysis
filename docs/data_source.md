# Data source log

## Source
- Dataset: CFPB Consumer Complaint Database (full bulk file)
- URL used: https://files.consumerfinance.gov/ccdb/complaints.csv.zip (primary; the fallback API URL was not needed)
- Downloaded: 2026-11-13T06:37:21+00:00 (UTC)
- Zip size: 366,121,838 bytes (366.1 MB); uncompressed CSV 5,797,256,221 bytes
- Raw file (untouched): `C:\data\cfpb\raw\complaints.csv.zip`
- Stored outside OneDrive; `data/` in the repo is git-ignored and empty.

## Filtering (scripts/filter_by_date.py)
- Only transformation: keep rows with `Date received` >= 2024-01-01 (format `YYYY-MM-DD`, all rows valid)
- Rows read: 19,112,942
- Rows written: 14,607,798
- Output: `C:\data\cfpb\processed\complaints_2024plus.csv` (4,471,385,574 bytes)

## MySQL
- Database: `cfpb`
- Table: `complaints_raw` (15 text columns, no cleaning; DDL in `sql/01_create_staging.sql`, load in `sql/02_load_staging.sql`)
- Rows loaded: 14,607,798 (matches the filtered CSV)
- Rows per year: 2024 = 2,734,253; 2025 = 5,442,926; 2026 = 6,430,619
- Date range: 2024-01-01 to 2026-11-12
- Profiling queries: `sql/03_profile_staging.sql`

## Notes
- The file has 15 columns; it has no consumer narrative, consent or disputed columns.
- The most recent month (2026-11) covers 12 days and averages 15,494.5 complaints/day vs 24,656.6 for 2026-10, so it looks partial or still arriving.
## Context sources for the Jan 2025 Block/Zelle complaint surge
- CFPB enforcement action, Block, Inc.: https://www.consumerfinance.gov/enforcement/actions/block-inc/
- Consumer Reports on influencer-driven Zelle and Cash App complaints: https://www.consumerreports.org/money/scams-fraud/cfpb-not-giving-money-to-people-scammed-on-zelle-cash-app-a9372236265/
- American Banker, influencers share false Zelle, Cash App advice: https://www.americanbanker.com/news/influencers-share-false-zelle-cash-app-advice-on-tiktok
- ConsumerAffairs summary: https://www.consumeraffairs.com/news/beware-of-influencers-bearing-tall-tales-the-cfpb-is-not-handing-out-money-091125.html
- Bloomberg Law, CFPB sues over Zelle fraud (2024-12-20): https://news.bloomberglaw.com/banking-law/cfpb-sues-jpmorgan-bank-of-america-over-alleged-zelle-fraud
