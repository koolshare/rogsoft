#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export dockroot)

case $ACTION in
start)
    echo "No running"
    ;;
*)
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
            curl -sSL -o ${DockRootBin} https://fw0.koolcenter.com/binary/DockRoot/DockRoot.arm64
            if [ "$?" -eq 0 ]; then
                echo "Downloaded DockRootBin successfully."
            else
                echo "Download failed"
                exit 1
            fi
            chmod +x $DockRootBin
        else
            echo "DockRootBin already exists and is valid."
        fi
        echo "Checking dependencies..."
        $DockRootBin ensuredeps
        if [ "$?" -eq 0 ]; then
            echo "Dependencies ensured successfully."
        else
            echo "Failed to ensure dependencies."
            exit 2
        fi
    fi
    http_response "$1"
    ;;
esac