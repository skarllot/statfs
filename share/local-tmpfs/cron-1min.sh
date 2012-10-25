#!/bin/bash

ROOT_PATH="/usr/local"
SHARE_PATH="${ROOT_PATH}/share/local-tmpfs"
ETC_PATH="${ROOT_PATH}/etc"
MOD_PATH="${SHARE_PATH}/modules"
CONF_FILE="${ETC_PATH}/local-tmpfs.cfg"
MCONF_FILE="${ETC_PATH}/local-tmpfs-1min.cfg"
LTMPFS_BIN="${SHARE_PATH}/manager.sh"

USAGE="Usage: $0 {updatefs|verbose-updatefs|create-config}"
RETVAL=0
VERBOSE=0
RETOK="        [  OK  ]"
RETFAIL="        [ FAIL ]"
prog=cron-1min

checkconf() {
    # Source configuration file
    if [ ! -r $CONF_FILE ]; then
        echo "The configuration file \"$CONF_FILE\" cannot be found"
        exit 1
    fi

    . $CONF_FILE

    if [ ! -r $MCONF_FILE ]; then
        echo "The configuration file \"$MCONF_FILE\" cannot be found"
        exit 1
    fi

    . $MCONF_FILE
}

checktmpfs() {
    $LTMPFS_BIN status &> /dev/null
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        $LTMPFS_BIN start &> /dev/null
        RETVAL=$?
    fi

    if [ ! $RETVAL -eq 0 ]; then
        echo "Cannot start \"$LTMPFS_BIN\""
        exit 1
    fi
}

updatefs() {
    for mod in $MODULES; do
	    MOD_FILE="${MOD_PATH}/$mod"

    	if [ -r "$MOD_FILE" ]; then
            [ ! -z $VERBOSE ] && echo "Updating module $mod..."

            $MOD_FILE $TMPFS_PATH $VERBOSE
            RETVAL=$?

            if [ ! -z $VERBOSE ] && [ ! $RETVAL -eq 0 ]; then
                echo "Failed to update module $mod"
            fi
        else
            [ ! -z $VERBOSE ] && echo "Module \"$mod\" cannot be found"
        fi
    done

    return $RETVAL
}

verboseupdatefs() {
    VERBOSE=1
    updatefs
    return $RETVAL
}

createconfig() {
    DEF_CFG="# $MCONF_FILE

# Space separated modules list
MODULES=\"example.sh\"
"   

    if [ -f $MCONF_FILE ]; then
        echo "Configuration file already exists"
        RETVAL=1
    else 
        echo "$DEF_CFG" > $MCONF_FILE
        echo "Configuration file created: $MCONF_FILE"
    fi
    return $RETVAL
}

case "$1" in
    updatefs)
        checkconf
        checktmpfs
        updatefs
        ;;
    verbose-updatefs)
        checkconf
        checktmpfs
        verboseupdatefs
        ;;
    create-config)
        createconfig
        ;;
    *)
        echo "$USAGE"
        RETVAL=2
esac

exit $RETVAL

