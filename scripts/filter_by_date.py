"""Stream the raw CFPB zip and keep rows with Date received >= 2024-01-01.

Date filtering is the only transformation; values are written unchanged.
Constant memory. Run with: python -I scripts/filter_by_date.py
"""
import csv
import io
import os
import re
import sys
import zipfile
from pathlib import Path

DATA_DIR = Path(os.environ.get("DATA_DIR", r"C:\data\cfpb"))
SRC = DATA_DIR / "raw" / "complaints.csv.zip"
DST = DATA_DIR / "processed" / "complaints_2024plus.csv"
CUTOFF = "2024-01-01"
ISO = re.compile(r"^\d{4}-\d{2}-\d{2}$")

csv.field_size_limit(sys.maxsize)


def main():
    DST.parent.mkdir(parents=True, exist_ok=True)
    read = written = bad_dates = short_rows = 0
    maxlen = None
    with zipfile.ZipFile(SRC) as z, z.open(z.namelist()[0]) as raw, \
            open(DST, "w", encoding="utf-8", newline="") as out:
        rd = csv.reader(io.TextIOWrapper(raw, encoding="utf-8", newline=""))
        wr = csv.writer(out, lineterminator="\n")
        hdr = next(rd)
        wr.writerow(hdr)
        maxlen = [0] * len(hdr)
        di = hdr.index("Date received")
        for row in rd:
            read += 1
            if len(row) != len(hdr):
                short_rows += 1
                print(f"WARNING: row {read} has {len(row)} fields", flush=True)
                continue
            d = row[di]
            if not ISO.match(d):
                bad_dates += 1
                continue
            if d >= CUTOFF:
                wr.writerow(row)
                written += 1
                for i, v in enumerate(row):
                    if len(v) > maxlen[i]:
                        maxlen[i] = len(v)
            if read % 2_000_000 == 0:
                print(f"  read {read:,} / kept {written:,}", flush=True)
    print(f"rows read:      {read:,}")
    print(f"rows written:   {written:,}")
    print(f"bad-date rows:  {bad_dates:,}")
    print(f"wrong-width:    {short_rows:,}")
    print(f"output:         {DST} ({DST.stat().st_size:,} bytes)")
    print("max length per column (kept rows):")
    for h, m in zip(hdr, maxlen):
        print(f"  {h}: {m}")


if __name__ == "__main__":
    main()
