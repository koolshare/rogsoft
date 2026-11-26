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

    def test_usb2jffs_system_mirror_requires_space_and_write_probe(self):
        installer = INSTALLER_PATH.read_text(encoding="utf-8")
        gate = installer.split("can_install_system_jffs(){", 1)[1].split(
            "\n}", 1
        )[0]
        install_now = installer.split("install_now(){", 1)[1].split("\n}", 1)[0]

        self.assertIn('du -sk "${PAYLOAD}"', gate)
        self.assertIn("awk 'NR == 2 {print $4}'", gate)
        self.assertIn("PAYLOAD_KB * 2 + 4096", gate)
        self.assertIn(".softcenter-write-test.$$", gate)
        self.assertIn(
            "can_install_system_jffs /cifs2 /tmp/${module}", install_now
        )
        self.assertIn("保留原系统副本并跳过本次镜像更新", install_now)


if __name__ == "__main__":
    unittest.main()
