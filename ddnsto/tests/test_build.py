"""Build real packages in an isolated checkout; never execute router binaries."""
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tarfile
import tempfile
import unittest


SOURCE = Path(__file__).resolve().parents[1]
PLATFORMS = ("hnd", "mtk", "ipq32", "ipq64", "qca")


class BuildTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="ddnsto build test ")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.module = self.root / "ddnsto"
        shutil.copytree(SOURCE, self.module,
                        ignore=shutil.ignore_patterns("tests", "*.tar.gz", ".build.*"))
        self.center = self.root / "softcenter"
        self.center.mkdir()
        for name in ("build_base.sh", "gen_install.py", "app.template.json.js", "config.json.js"):
            shutil.copy2(SOURCE.parent / "softcenter" / name, self.center / name)
        self.version = re.search(r'^VERSION="([^"]+)"',
                                 (SOURCE / "build.sh").read_text(), re.M)[1]

    def run_build(self, entry="build.sh", *args, shell="sh"):
        return subprocess.run([shell, str(self.module / entry), *args],
                              cwd=self.root, capture_output=True, text=True)

    def snapshot(self, directory):
        return {str(p.relative_to(directory)): (p.read_bytes(), p.stat().st_mode)
                for p in directory.rglob("*") if p.is_file()}

    def assert_package(self, platform):
        archive = self.module / "ddnsto.tar.gz"
        digest = hashlib.md5(archive.read_bytes()).hexdigest()
        metadata = json.loads((self.module / "config.json.js").read_text())
        self.assertEqual(metadata["version"], self.version)
        self.assertEqual(metadata["md5"], digest)
        self.assertEqual((self.module / "version").read_text().splitlines(),
                         [self.version, digest])
        with tarfile.open(archive) as package:
            files = {m.name: m for m in package.getmembers() if m.isfile()}
            expected = self.snapshot(self.module / "ddnsto")
            self.assertEqual(set(files), {"ddnsto/" + p for p in expected})
            for path, (contents, mode) in expected.items():
                name = "ddnsto/" + path
                if path == ".valid":
                    contents = (platform + "\n").encode()
                elif path == "version":
                    contents = (self.version + "\n").encode()
                self.assertEqual(package.extractfile(name).read(), contents, name)
                if path.startswith("bin/") or path.endswith(".sh"):
                    self.assertTrue(files[name].mode & 0o111, name)
        apps = json.loads((self.center / "app.json.js").read_text())["apps"]
        app = next(a for a in apps if a["name"] == "ddnsto")
        self.assertEqual(app["version"], self.version)
        self.assertEqual(app["md5"], digest)
        self.assertEqual(app["tar_url"], "ddnsto/ddnsto.tar.gz")
        self.assertEqual(list(self.module.glob(".build.*")), [])

    def test_platform_entries_preserve_sources_and_package_both_binaries(self):
        before = self.snapshot(self.module / "ddnsto")
        for platform in PLATFORMS:
            with self.subTest(platform=platform):
                result = self.run_build("build_" + platform + ".sh")
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assert_package(platform)
                self.assertEqual(self.snapshot(self.module / "ddnsto"), before)

    def test_explicit_platform_overrides_source_marker(self):
        result = self.run_build("build.sh", "mtk", shell="bash")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assert_package("mtk")

    def test_default_remains_hnd_even_after_another_platform_build(self):
        result = self.run_build("build.sh", "qca")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        result = self.run_build()
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assert_package("hnd")

    def test_invalid_platform_and_extra_arguments_leave_outputs_unchanged(self):
        before = self.snapshot(self.module)
        for args in (("armsoft",), ("invalid",), ("mtk", "qca")):
            with self.subTest(args=args):
                result = self.run_build("build.sh", *args)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("Usage:", result.stderr)
                self.assertEqual(self.snapshot(self.module), before)

    def test_missing_binary_fails_without_overwriting_previous_package(self):
        (self.module / "ddnsto.tar.gz").write_bytes(b"previous package")
        (self.module / "ddnsto/bin/ddnsto_arm").unlink()
        before = self.snapshot(self.module)
        result = self.run_build("build.sh", "mtk")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("ddnsto_arm", result.stderr)
        self.assertEqual(self.snapshot(self.module), before)


if __name__ == "__main__":
    unittest.main()
