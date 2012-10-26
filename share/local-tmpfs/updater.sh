#!/bin/bash
#
# updater       Updater manager pseudo-daemon
#
# description:  Updater manager allows to control local tmpfs update \
#               through pseudo-daemon (via cron).

USAGE_PARAMS="{start|stop|force-stop|restart|status}"

COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE


prog=updater

CRON_CFG=([0]="*/1 * * * *" [1]="*/5 * * * *" [2]="*/15 * * * *" \
[3]="0 * * * *" [4]="0 0 * * *")
UPMOD_MODES=([0]="min1" [1]="min5" [2]="min15" [3]="hour" [4]="day")
TMP_FILE="${SHARE_PATH}/tmp-cron"
CRON_BLOCK="# Automatically created by ${SHARE_PATH}/updater.sh"

start() {
    echo -n "Starting $prog: "

    CMDRET=$(status)
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "$prog is already running"
        RETVAL=1
    else
        CMDRET=$(crontab -l 2> /dev/null)
        RETVAL=$?

        if [ ! $RETVAL -eq 0 ]; then
            echo "No \"crontab\" command found"
            return $RETVAL
        fi

        CMDRET="${CMDRET}

${CRON_BLOCK}"
        echo "${CMDRET}" > ${TMP_FILE}
        crontab ${TMP_FILE}
        RETVAL=$?
        rm -f $TMP_FILE

        if [ $RETVAL -eq 0 ]; then
            echo "$RETOK"
        else
            echo "$RETFAIL"
        fi
    fi
    return $RETVAL
}

stop() {
    echo -n "Stopping $prog: "

    CMDRET=$(status)
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "$prog is not running"
        RETVAL=1
    else
        CMDRET=$(crontab -l 2> /dev/null)
        RETVAL=$?

        IFS_COPY=$IFS
        IFS=$'\n'
        for line in $CRON_BLOCK; do
            CMDRET=$(echo "$CMDRET" | grep -v "${line//\*/\\*}")
        done
        IFS=$IFS_COPY

        echo "${CMDRET}" > ${TMP_FILE}
        crontab ${TMP_FILE}
        RETVAL=$?
        rm -f $TMP_FILE

        if [ $RETVAL -eq 0 ]; then
            echo "$RETOK"
        else
            echo "$RETFAIL"
        fi
    fi
    return $RETVAL
}

forcestop() {
    echo -n "Forcing stop $prog: "

    CMDRET=$(crontab -l | grep -v "$UPMOD_BIN" 2> /dev/null)
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        echo "No \"crontab\" command found"
        return $RETVAL
    fi

    echo "$CMDRET" > $TMP_FILE
    crontab $TMP_FILE
    RETVAL=$?
    rm -f $TMP_FILE

    if [ $RETVAL -eq 0 ]; then
        echo "$RETOK"
    else
        echo "$RETFAIL"
    fi
    return $RETVAL
}

restart() {
    start
    stop
}

status() {
    CRONRET=$(crontab -l 2> /dev/null)
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        echo "No \"crontab\" command found"
        return $RETVAL
    fi

    CMDRET=$(echo "$CRONRET" | grep "$UPMOD_BIN" | wc -l)
    if [ $CMDRET -eq 0 ]; then
        echo "$prog is stopped"
        return 3
    fi

    IFS_COPY=$IFS
    IFS=$'\n'
    for line in $CRON_BLOCK; do
        CMDRET=$(echo "$CRONRET" | grep "${line//\*/\\*}" | wc -l)
        if [ ! $CMDRET -eq 1 ]; then
            echo "Incorrect configuration found into crontab configuration"
            echo "Try \"$0 force-stop\" to correct this"
echo "$line"
            RETVAL=3
        fi
    done
    IFS=$IFS_COPY

    if [ ! $RETVAL -eq 0 ]; then
        echo "$prog is stopped"
    else
        echo "$prog is running..."
    fi
    return $RETVAL
}

for i in {0..4}; do
    CRON_BLOCK="${CRON_BLOCK}
${CRON_CFG[$i]} ${UPMOD_BIN} updatefs ${UPMOD_MODES[$i]}"
done

case "$1" in
    start)
        checkconf
        start
        ;;
    stop)
        checkconf
        stop
        ;;
    force-stop)
        checkconf
        forcestop
        ;;
    restart)
        checkconf
        restart
        ;;
    status)
        checkconf
        status
        ;;
    *)
        echo "$USAGE"
        RETVAL=2
esac

exit $RETVAL
