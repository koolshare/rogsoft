import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INSTALL_SCRIPT = ROOT / "floatip" / "install.sh"


class FloatipInstallContractTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.script = INSTALL_SCRIPT.read_text(encoding="utf-8")

    def test_installed_executable_name_is_used_consistently(self):
        self.assertIn(
            "chmod 755 /koolshare/bin/${module}_bin",
            self.script,
        )
        self.assertIn(
            "dbus set floatip_client_version=$(/koolshare/bin/floatip_bin -v)",
            self.script,
        )


if __name__ == "__main__":
    unittest.main()
