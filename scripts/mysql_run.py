"""Run mysql.exe with credentials from .env, without echoing them.

Usage:
    python scripts/mysql_run.py [--local-infile] [--db NAME] -e "SQL"
    python scripts/mysql_run.py [--local-infile] [--db NAME] -f path/to/file.sql
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path

from dotenv import dotenv_values

MYSQL = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
ENV_PATH = Path(__file__).resolve().parent.parent / ".env"


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--local-infile", action="store_true")
    p.add_argument("--db")
    p.add_argument("--table", action="store_true", help="tabular output")
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("-e")
    g.add_argument("-f")
    a = p.parse_args()

    cfg = dotenv_values(ENV_PATH)
    cmd = [MYSQL, f"--user={cfg['MYSQL_USER']}", "--default-character-set=utf8mb4"]
    if a.table:
        cmd.append("--table")
    if a.local_infile:
        cmd.append("--local-infile=1")
    if a.db:
        cmd.append(f"--database={a.db}")
    env = dict(os.environ, MYSQL_PWD=cfg["MYSQL_PASSWORD"])

    if a.e:
        cmd += ["-e", a.e]
        stdin = None
    else:
        stdin = open(a.f, "r", encoding="utf-8")
    r = subprocess.run(cmd, env=env, stdin=stdin, capture_output=True, text=True, encoding="utf-8")
    sys.stdout.write(r.stdout)
    # Defensive: never let the password appear in output
    err = r.stderr.replace(cfg["MYSQL_PASSWORD"], "***")
    sys.stderr.write(err)
    sys.exit(r.returncode)


if __name__ == "__main__":
    main()
