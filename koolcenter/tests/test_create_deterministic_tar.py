import importlib.util
import os
import pathlib
import tarfile
import tempfile
import unittest


SCRIPT_PATH = pathlib.Path(__file__).parents[1] / "create_deterministic_tar.py"
SPEC = importlib.util.spec_from_file_location("create_deterministic_tar", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class DeterministicTarTest(unittest.TestCase):
    def test_same_content_produces_identical_archives_and_normalized_metadata(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = pathlib.Path(temporary_directory)
            first_source = self._create_tree(root / "first", 100)
            second_source = self._create_tree(root / "second", 200)
            first_archive = root / "first.tar.gz"
            second_archive = root / "second.tar.gz"

            MODULE.create_deterministic_tar(first_source, first_archive, mtime=0)
            MODULE.create_deterministic_tar(second_source, second_archive, mtime=0)

            self.assertEqual(first_archive.read_bytes(), second_archive.read_bytes())
            with tarfile.open(first_archive, "r:gz") as archive:
                members = archive.getmembers()
                self.assertEqual(
                    [member.name for member in members],
                    [
                        "softcenter",
                        "softcenter/bin",
                        "softcenter/bin/tool",
                        "softcenter/link",
                        "softcenter/version",
                    ],
                )
                self.assertTrue(all(member.uid == 0 for member in members))
                self.assertTrue(all(member.gid == 0 for member in members))
                self.assertTrue(all(member.mtime == 0 for member in members))
                self.assertEqual(archive.getmember("softcenter/link").linkname, "version")

    @staticmethod
    def _create_tree(root, mtime):
        source = root / "softcenter"
        (source / "bin").mkdir(parents=True)
        (source / "version").write_text("1.9.57\n", encoding="utf-8")
        executable = source / "bin" / "tool"
        executable.write_text("#!/bin/sh\n", encoding="utf-8")
        executable.chmod(0o755)
        (source / "link").symlink_to("version")
        for path in [source, source / "bin", source / "version", executable]:
            os.utime(path, (mtime, mtime), follow_symlinks=False)
        return source


if __name__ == "__main__":
    unittest.main()
