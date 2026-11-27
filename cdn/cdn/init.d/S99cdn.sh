#!/bin/sh
case "${1:-start}" in
    start|restart) /koolshare/cdn/endpoint.sh boot ;;
    stop) /koolshare/cdn/endpoint.sh stop ;;
esac
