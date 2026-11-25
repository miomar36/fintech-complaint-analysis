"""Export cfpb.fintech_clean to CSV (header, UTF-8, NULL -> empty, dates YYYY-MM-DD).

Credentials come from .env (MYSQL_USER, MYSQL_PASSWORD); the password is never printed.

Usage:
    python scripts/export_clean.py [--out PATH]

Default output: $DATA_DIR/processed/fintech_clean.csv (DATA_DIR defaults to C:/data/cfpb).
"""
import argparse
import csv
import datetime
import os
import sys
from pathlib import Path

import pymysql
from dotenv import dotenv_values

ENV_PATH = Path(__file__).resolve().parent.parent / ".env"
DATA_DIR = Path(os.environ.get("DATA_DIR", r"C:\data\cfpb"))


def fmt(v):
    if v is None:
        return ""
    if isinstance(v, (datetime.date, datetime.datetime)):
        return v.strftime("%Y-%m-%d")
    return v


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--out", type=Path, default=DATA_DIR / "processed" / "fintech_clean.csv")
    a = p.parse_args()
    a.out.parent.mkdir(parents=True, exist_ok=True)

    cfg = dotenv_values(ENV_PATH)
    try:
        conn = pymysql.connect(
            host=cfg.get("MYSQL_HOST") or "localhost",
            user=cfg["MYSQL_USER"],
            password=cfg["MYSQL_PASSWORD"],
            database="cfpb",
            charset="utf8mb4",
            cursorclass=pymysql.cursors.SSCursor,  # stream rows
        )
    except pymysql.MySQLError as e:
        # Defensive: never let the password appear in output
        sys.exit("Connection failed: " + str(e).replace(cfg["MYSQL_PASSWORD"], "***"))

    n = 0
    with conn, conn.cursor() as cur, open(a.out, "w", encoding="utf-8", newline="") as f:
        cur.execute("SELECT * FROM fintech_clean")
        w = csv.writer(f, lineterminator="\n")
        w.writerow([d[0] for d in cur.description])
        for row in cur:
            w.writerow([fmt(v) for v in row])
            n += 1
    print(f"Wrote {n} data rows to {a.out}")


if __name__ == "__main__":
    main()
