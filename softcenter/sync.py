#!/usr/bin/env python3
"""Compatibility entry point for the software-center maintenance tools."""

import os
from pathlib import Path
import sys


def main(center="softcenter"):
    args = sys.argv[1:]
    if args not in ([], ["sync"], ["refresh"]):
        print("usage: sync.py [sync|refresh]", file=sys.stderr)
        return 2
    source = Path(__file__).resolve().parents[1]
    configured = os.environ.get("ASUSGO_BUILD_ROOT")
    if configured:
        candidates = [Path(configured).expanduser().resolve()]
    else:
        candidates = [
            source.parent / "asusgo-build",
            source.parent.parent / "asusgo-build",
            source.parent / "asusgo-softcenter-build-bash",
            source.parent / "asusgo-softcenter-build",
        ]
    for tools in candidates:
        if (tools / "lib/sync.sh").is_file() and (tools / "sync.sh").is_file():
            os.environ.setdefault("PROXYC", "")
            os.execvp("bash", [
                "bash", str(tools / "sync.sh"), str(source), (args or ["sync"])[0], center
            ])
    print("Set ASUSGO_BUILD_ROOT to the maintenance tools checkout with lib/sync.sh.", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
