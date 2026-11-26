#!/usr/bin/env python3
"""Compatibility entry point using koolcenter/modules.json."""

from pathlib import Path
from runpy import run_path
import sys


if __name__ == "__main__":
    sync = run_path(str(Path(__file__).resolve().parents[1] / "softcenter" / "sync.py"))
    sys.exit(sync["main"](center="koolcenter"))
