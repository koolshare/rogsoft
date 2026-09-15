from pathlib import Path
import unittest


INSTALLER_PATH = (
    Path(__file__).parents[2] / "softcenter" / "softcenter" / "install.sh"
)


class InstallVersionContractTest(unittest.TestCase):
    def test_jffs_install_updates_dbus_without_requiring_usb2jffs(self):
        installer = INSTALLER_PATH.read_text(encoding="utf-8")
        version_block = installer.split("local SOFTVER=", 1)[1].split(
            "# run something after install", 1
        )[0]

        self.assertIn('if [ "${KSHOME}" == "jffs" ];then', version_block)
        self.assertNotIn(
            'if [ "${KSHOME}" == "jffs" -a -f "/cifs2/ksdb/log" ];then',
            version_block,
        )
        self.assertIn("dbus set softcenter_version=${SOFTVER}", version_block)


if __name__ == "__main__":
    unittest.main()
