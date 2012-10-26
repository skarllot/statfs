#!/bin/bash
#
# common        Common variables and functions to local-tmpfs

ROOT_PATH="/usr/local"
SHARE_PATH="${ROOT_PATH}/share/local-tmpfs"
ETC_PATH="${ROOT_PATH}/etc"
MOD_PATH="${SHARE_PATH}/modules"

CONF_FILE="${ETC_PATH}/local-tmpfs.cfg"
LTMPFS_BIN="${SHARE_PATH}/manager.sh"

USAGE="Usage: $0 $USAGE_PARAMS"
RETVAL=0
RETOK="        [  OK  ]"
RETFAIL="        [ FAIL ]"

checkconf() {
    # Default values
    TMPFS_PATH=/usr/local/var
    FS_SIZE=50m
    MODULES_MIN="example.sh"
    MODULES_5MIN=""
    MODULES_15MIN=""
    MODULES_HOUR=""
    MODULES_DAY=""

    # Source configuration file
    if [ ! -r $CONF_FILE ]; then
        echo "The configuration file \"$CONF_FILE\" cannot be found"
        exit 1
    fi

    . $CONF_FILE
}

