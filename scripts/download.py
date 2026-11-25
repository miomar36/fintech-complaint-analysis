"""Download the CFPB complaint data into DATA_DIR/raw (default C:\\data\\cfpb\\raw).

Tries the full bulk zip first, then the filtered API CSV. Raw files are never modified.
Run with: python -I scripts/download.py
"""
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

import requests

DATA_DIR = Path(os.environ.get("DATA_DIR", r"C:\data\cfpb"))
RAW = DATA_DIR / "raw"
RAW.mkdir(parents=True, exist_ok=True)

SOURCES = [
    ("primary (bulk zip)",
     "https://files.consumerfinance.gov/ccdb/complaints.csv.zip",
     RAW / "complaints.csv.zip"),
    ("fallback (search API)",
     "https://www.consumerfinance.gov/data-research/consumer-complaints/search/api/v1/"
     "?date_received_min=2024-01-01&format=csv&no_aggs=true",
     RAW / "complaints_api_2024plus.csv"),
]


def fetch(url, dest):
    tmp = dest.with_suffix(dest.suffix + ".part")
    with requests.get(url, stream=True, timeout=(30, 300),
                      headers={"User-Agent": "fintech-complaint-analysis/1.0"}) as r:
        r.raise_for_status()
        total = int(r.headers.get("Content-Length", 0))
        done = 0
        with open(tmp, "wb") as f:
            for chunk in r.iter_content(chunk_size=1 << 20):
                f.write(chunk)
                done += len(chunk)
                if done % (100 << 20) < (1 << 20):
                    print(f"  {done / 1e6:,.0f} MB" + (f" / {total / 1e6:,.0f} MB" if total else ""), flush=True)
    tmp.replace(dest)


def main():
    for label, url, dest in SOURCES:
        print(f"Trying {label}: {url}", flush=True)
        try:
            start = datetime.now(timezone.utc)
            fetch(url, dest)
        except Exception as e:  # noqa: BLE001
            print(f"  FAILED: {type(e).__name__}: {e}", flush=True)
            continue
        end = datetime.now(timezone.utc)
        print("SUCCESS")
        print(f"URL used:   {url}")
        print(f"File:       {dest}")
        print(f"Size:       {dest.stat().st_size:,} bytes ({dest.stat().st_size / 1e6:,.1f} MB)")
        print(f"Downloaded: {end.isoformat(timespec='seconds')} (started {start.isoformat(timespec='seconds')})")
        return 0
    print("Both downloads failed. Export manually from the CFPB search page.")
    return 1


if __name__ == "__main__":
    sys.exit(main())
