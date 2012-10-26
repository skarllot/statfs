#!/bin/bash
#
# upmod         Updater script
#
# description:  Updater that handles, through modules, update for local \
#               tmpfs files. This script is intended to be runned via cron.

USAGE_PARAMS="{updatefs|verbose-updatefs} {min1|min5|min15|hour|day}"

COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE


VERBOSE=0
prog=upmod

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

checkparam2() {
    case "$P2" in
        min1)
            MODULES=$MODULES_MIN
            ;;
        min5)
            MODULES=$MODULES_MIN5
            ;;
        min15)
            MODULES=$MODULES_MIN15
            ;;
        hour)
            MODULES=$MODULES_HOUR
            ;;
        day)
            MODULES=$MODULES_DAY
            ;;
        *)
            echo "$USAGE"
        RETVAL=2
    esac
    return $RETVAL
}

P2=$2
case "$1" in
    updatefs)
        checkconf
        checkparam2
        checktmpfs
        updatefs
        ;;
    verbose-updatefs)
        checkconf
        checkparam2
        checktmpfs
        verboseupdatefs
        ;;
    *)
        [ ! $RETVAL -eq 2 ] && echo "$USAGE"
        RETVAL=2
esac

exit $RETVAL
