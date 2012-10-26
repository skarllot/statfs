#!/bin/bash
#
# common        Common variables and functions to local-tmpfs

ROOT_PATH="/usr/local"
SHARE_PATH="${ROOT_PATH}/share/local-tmpfs"
ETC_PATH="${ROOT_PATH}/etc"
MOD_PATH="${SHARE_PATH}/modules"

CONF_FILE="${ETC_PATH}/local-tmpfs.cfg"
LTMPFS_BIN="${SHARE_PATH}/manager.sh"

USAGE="Usage: $0 {$AVAIL_FUNC}"
RETVAL=0
RETOK="        [  OK  ]"
RETFAIL="        [ FAIL ]"

checkconf() {
    # Source configuration file
    if [ ! -r $CONF_FILE ]; then
        echo "The configuration file \"$CONF_FILE\" cannot be found"
        exit 1
    fi

    . $CONF_FILE
}

