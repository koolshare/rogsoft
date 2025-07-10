#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
LOG_FILE=/tmp/upload/homeassistant_log.txt
eval $(dbus export dockroot)
eval $(dbus export homeassistant)
INST_NAME=homeassistant

check_dockroot() {
    DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
    if [ -f "$DockRootBin" ]; then
        version_output=$($DockRootBin -v 2>&1)
        if echo "$version_output" | grep -iq "version"; then
            return 0
        fi
    fi
    return 1
}

check_image() {
    DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
    if ! ${DockRootBin} ps|grep -iq ${INST_NAME}; then
        return 1
    fi
    if ${DockRootBin} run ${INST_NAME} echo testvalid | grep -q testvalid; then
        return 0
    else
        return 2
    fi
}

install_homeassistant() {
    DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
    PIDS=`${DockRootBin} ps ${INST_NAME}|tr -d '[:space:]'`
    if [ -n "$PIDS" ]; then
        echo "Already running" >> ${LOG_FILE}
        return 0
    fi
    check_dockroot
    if [ "$?" -ne 0 ]; then
        echo "DockRoot not installed" >> ${LOG_FILE}
        return 1
    fi
    check_image
    if [ "$?" -ne 0 ]; then
        echo "DockRoot image not installed, installing" >> ${LOG_FILE}
        ${DockRootBin} pull homeassistant/home-assistant:latest ${INST_NAME}|tee -a ${LOG_FILE}
    fi
    ${DockRootBin} run -d ${INST_NAME} | tee -a ${LOG_FILE}
    return 0
}

start_homeassistant() {
    DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
    PIDS=`${DockRootBin} ps ${INST_NAME}|tr -d '[:space:]'`
    if [ -n "$PIDS" ]; then
        echo "Already running" >> ${LOG_FILE}
        return 0
    fi
    check_dockroot
    if [ "$?" -ne 0 ]; then
        echo "DockRoot not installed" >> ${LOG_FILE}
        return 1
    fi
    check_image
    if [ "$?" -ne 0 ]; then
        return 2
    fi
    ${DockRootBin} run -d ${INST_NAME} | tee -a ${LOG_FILE}
    return 0
}

case $ACTION in
start)
    start_homeassistant
    ;;
*)
    # 如果安装中，则不要触碰日志文件
    if ps | grep -q "DockRoot pull homeassistant/home-assistant"; then
        echo "Already installing"
        sleep 10
        http_response "$1"
        exit 2
    fi

    # TODO: DockRoot stop ${INST_NAME}
    echo "HomeAssistant - 安装中..." > ${LOG_FILE}
    install_homeassistant
    if [ "$?" -eq 0 ]; then
       echo "HomeAssistant - 等待运行" >> ${LOG_FILE}
       sleep 5
       echo "HomeAssistant - 安装成功" >> ${LOG_FILE}
    else
       echo "HomeAssistant - 安装失败" >> ${LOG_FILE}
    fi
	echo "XU6J03M6" >> ${LOG_FILE}
    http_response "$1"
    ;;
esac
