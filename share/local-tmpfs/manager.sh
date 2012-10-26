#!/bin/bash
#
# manager       Startup script for local tmpfs
#
# description:  Local tmpfs provides infrastructure for third-party \
#               information beyond memory file system.
# config: /usr/local/etc/local-tmpfs.cfg

MOUNT_FLAGS="rw,nosuid,noexec,nodev,mode=0755"
AVAIL_FUNC="start|stop|restart|status"

COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE


prog=manager

start() {
    echo -n "Starting $prog: "

    CMDRET=$(status)
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "$prog is already running"
        RETVAL=1
    else
        if [ ! -d "$TMPFS_PATH" ]; then
            mkdir -p "$TMPFS_PATH"
            RETVAL=$?
            [ ! $RETVAL -eq 0 ] && return $RETVAL
        fi

        mount -t tmpfs -o ${MOUNT_FLAGS},size=$FS_SIZE tmpfs $TMPFS_PATH
        RETVAL=$?

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
        umount $TMPFS_PATH
        RETVAL=$?

        if [ $RETVAL -eq 0 ]; then
            echo "$RETOK"
        else
            echo "$RETFAIL"
        fi
    fi
    return $RETVAL
}

restart() {
    start
    stop
}

status() {
    CMDRET=$(mount)
    CMDRET=$(echo "$CMDRET" | grep tmpfs | grep $TMPFS_PATH | wc -l)
    if [ ! $CMDRET -eq 1 ]; then
        echo "$prog is stopped"
        RETVAL=3
    else
        echo "$prog is running..."
        RETVAL=0
    fi
    return $RETVAL
}

case "$1" in
    start)
        checkconf
        start
        ;;
    stop)
        checkconf
        stop
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

