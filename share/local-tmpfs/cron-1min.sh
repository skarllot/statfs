#!/bin/bash
#
# cron-1min     Updater script for fast modules
#
# description:  Updater script for fast modules, intended to be \
#               run minutely by cron.

AVAIL_FUNC="updatefs|verbose-updatefs"

COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE


VERBOSE=0
prog=cron-1min

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
    for mod in $MODULES_FAST; do
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
    *)
        echo "$USAGE"
        RETVAL=2
esac

exit $RETVAL

