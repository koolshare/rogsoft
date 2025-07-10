#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
LOG_FILE=/tmp/upload/dockroot_log.txt
eval $(dbus export dockroot)

install_dockroot() {
    if [ -d "${dockroot_path_selected}" ]; then
        DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
        DockRootOK=0
        if [ -f "$DockRootBin" ]; then
            version_output=$($DockRootBin -v 2>&1)
            if echo "$version_output" | grep -iq "version"; then
                DockRootOK=1
            fi
        fi
        if [ "$DockRootOK" -eq 0 ]; then
            mkdir -p ${dockroot_path_selected}/DockRootBin
            echo "Downloading..." >> ${LOG_FILE}
            curl -sSL -o ${DockRootBin} https://fw0.koolcenter.com/binary/DockRoot/DockRoot.arm64
            if [ "$?" -eq 0 ]; then
                echo "Downloaded DockRootBin successfully." >> ${LOG_FILE}
            else
                echo "Download failed" >> ${LOG_FILE}
                return 1
            fi
            chmod 755 $DockRootBin
            rm -f /koolshare/bin/DockRoot
            ln -s ${DockRootBin} /koolshare/bin/DockRoot
        else
            echo "DockRootBin already exists and is valid." >> ${LOG_FILE}
        fi
        echo "Checking dependencies..." >> ${LOG_FILE}
        $DockRootBin ensuredeps
        if [ "$?" -eq 0 ]; then
            echo "Dependencies ensured successfully." >> ${LOG_FILE}
        else
            echo "Failed to ensure dependencies." >> ${LOG_FILE}
            return 2
        fi
    fi
    return 0
}

case $ACTION in
start)
    echo "No running"
    ;;
*)
    echo "DockRoot - 安装中..." > ${LOG_FILE}
    install_dockroot
    if [ "$?" -eq 0 ]; then
       echo "DockRoot - 安装成功" >> ${LOG_FILE}
    else
       echo "DockRoot - 安装失败" >> ${LOG_FILE}
    fi
	echo "XU6J03M6" >> ${LOG_FILE}
    http_response "$1"
    ;;
esac
