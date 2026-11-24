#!/usr/bin/env python3
"""Create the reproducible softcenter.tar.gz release artifact."""

import argparse
import gzip
import os
from pathlib import Path
import tarfile


def create_deterministic_tar(source_directory, output_path, mtime=0):
    source = Path(source_directory)
    output = Path(output_path)
    if not source.is_dir():
        raise ValueError("source directory does not exist: {}".format(source))

    entries = [source]
    entries.extend(
        sorted(
            source.rglob("*"),
            key=lambda entry: entry.relative_to(source).as_posix(),
        )
    )
    output.parent.mkdir(parents=True, exist_ok=True)

    with output.open("wb") as raw_archive:
        with gzip.GzipFile(
            filename="",
            mode="wb",
            fileobj=raw_archive,
            compresslevel=9,
            mtime=int(mtime),
        ) as compressed_archive:
            with tarfile.open(
                fileobj=compressed_archive,
                mode="w",
                format=tarfile.PAX_FORMAT,
            ) as archive:
                for entry in entries:
                    relative_path = entry.relative_to(source)
                    archive_name = Path("softcenter") / relative_path
                    info = archive.gettarinfo(str(entry), archive_name.as_posix())
                    info.uid = 0
                    info.gid = 0
                    info.uname = "root"
                    info.gname = "root"
                    info.mtime = int(mtime)
                    info.pax_headers = {}
                    if info.isfile():
                        with entry.open("rb") as file_content:
                            archive.addfile(info, file_content)
                    else:
                        archive.addfile(info)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source_directory")
    parser.add_argument("output_path")
    parser.add_argument(
        "--mtime",
        type=int,
        default=int(os.environ.get("SOURCE_DATE_EPOCH", "0")),
    )
    arguments = parser.parse_args()
    create_deterministic_tar(
        arguments.source_directory,
        arguments.output_path,
        mtime=arguments.mtime,
    )


if __name__ == "__main__":
    main()
