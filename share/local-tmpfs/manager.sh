#!/bin/bash
#
# Provides management to memory filesystem mounting.
#
# Copyright (C) 2012 Fabrício Godoy <skarllot@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.
#
# Authors: Fabrício Godoy <skarllot@gmail.com>
#

# --------------------------------------------------------------
# Initial setup
# --------------------------------------------------------------

# Mandatory config for common.sh
readonly USAGE_PARAMS="{mount|umount|remount|status|help}"
readonly PROG=manager.sh

# Source common script (common.sh)
COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE

# General config
readonly MOUNT_FLAGS="rw,nosuid,noexec,nodev,mode=0755"

help() {
    cat <<EOF
USAGE
        $PROG <action>


DESCRIPTION
        $PROG provides management to memory filesystem mounting.

        The memory filesystem is the core functionality for local-tmpfs, it
        will store all third-party information provided by modules.


ACTIONS
        . help
                Shows this help screen.

        . mount
                Attach a new memory filesystem.

        . remount
                Detach the existing memory filesystem and attach a new one.

        . status
                Check if the memory filesystem is attached or not.

        . umount
                Detach the attached memory filesystem


FILES
        $CONF_FILE: configuration file for local-tmpfs


VERSION
        $VERSION
EOF
    exit 0
}

start() {
    echo -n "Mounting tmpfs: "

    status > /dev/null
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "tmpfs is already mounted"
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
    echo -n "Unmount tmpfs: "

    status > /dev/null
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "tmpfs is not mounted"
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
        echo "tmpfs is not mounted"
        RETVAL=3
    else
        echo "tmpfs is mounted"
        RETVAL=0
    fi

    return $RETVAL
}

case "$1" in
    mount)
        checkconf
        start
        ;;
    umount)
        checkconf
        stop
        ;;
    remount)
        checkconf
        restart
        ;;
    status)
        checkconf
        status
        ;;
    help|h|-h|--help)
        help
        ;;
    *)
        RETVAL=2
        usage
esac

exit $RETVAL

