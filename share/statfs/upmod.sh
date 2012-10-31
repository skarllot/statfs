#!/bin/bash
#
# upmod         Updater script
#
# description:  Updater that handles, through modules, update for statfs \
#               files. This script is intended to be runned via cron.

USAGE_PARAMS="{updatefs|verbose-updatefs} {min1|min5|min15|hour|day}"

COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE


VERBOSE=0
prog=upmod

checkstatfs() {
    $MANAGER_BIN status &> /dev/null
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        $MANAGER_BIN mount &> /dev/null
        RETVAL=$?
    fi

    if [ ! $RETVAL -eq 0 ]; then
        echo "Error calling \"$MANAGER_BIN mount\""
        exit 1
    fi
}

updatefs() {
    for mod in $MODULES; do
        MOD_FILE="${MOD_PATH}/$mod"

        if [ -r "$MOD_FILE" ]; then
            [ ! $VERBOSE -eq 0 ] && echo "Updating module $mod..."

            $MOD_FILE $STATFS_PATH $VERBOSE
            RETVAL=$?

            if [ ! -z $VERBOSE ] && [ ! $RETVAL -eq 0 ]; then
                echo "Failed to update module $mod"
            fi
        else
            [ ! $VERBOSE -eq 0 ] && echo "Module \"$mod\" cannot be found"
        fi
    done

    return $RETVAL
}

verboseupdatefs() {
    VERBOSE=1
    updatefs
    return $RETVAL
}

checkparam2() {
    case "$P2" in
        min1)
            MODULES=$MODULES_MIN
            ;;
        min5)
            MODULES=$MODULES_5MIN
            ;;
        min15)
            MODULES=$MODULES_15MIN
            ;;
        hour)
            MODULES=$MODULES_HOUR
            ;;
        day)
            MODULES=$MODULES_DAY
            ;;
        *)
            RETVAL=2
            usage
    esac
    return $RETVAL
}

P2=$2
case "$1" in
    updatefs)
        checkconf
        checkparam2
        checkstatfs
        updatefs
        ;;
    verbose-updatefs)
        checkconf
        checkparam2
        checkstatfs
        verboseupdatefs
        ;;
    *)
        RETVAL=2
        usage
esac

exit $RETVAL

