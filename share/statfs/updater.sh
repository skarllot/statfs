#!/bin/bash
#
# Manager to schedule modules execution.
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
readonly USAGE_PARAMS="{schedule|unschedule|force-unschedule|reschedule\
|status|help}"
readonly PROG=updater.sh

# Source common script (common.sh)
COMMON_FILE="$(dirname $0)/common.sh"
if [ ! -r $COMMON_FILE ]; then
    echo "Common script file \"$COMMON_FILE\" cannot be found"
    exit 1
fi

. $COMMON_FILE

# General config
readonly CRON_CFG=([0]="*/1 * * * *" [1]="*/5 * * * *" [2]="*/15 * * * *" \
[3]="0 * * * *" [4]="0 0 * * *")
readonly UPMOD_MODES=([0]="min1" [1]="min5" [2]="min15" [3]="hour" [4]="day")
readonly TMP_FILE="${SHARE_PATH}/tmp-cron"
readonly CRON_HEADER="# Automatically created by ${SHARE_PATH}/${PROG}"
CRON_BLOCK=$CRON_HEADER

# --------------------------------------------------------------
# Functions
# --------------------------------------------------------------

help() {
    cat <<EOF
USAGE
        $PROG <action>


DESCRIPTION
        $PROG manages scheduling of modules execution.

        After the statfs mounting it will be empty until modules execution.
        This script schedules modules execution to various execution frequency
        into root crontab.


ACTIONS
        . force-unschedule
                Unschedules modules execution from root crontab by removing all
                references to "upmod.sh", use with care.

        . help
                Shows this help screen.

        . schedule
                Schedules modules execution to root crontab.

        . reschedule
                Unschedules and schedules modules execution.

        . status
                Check if the modules execution is scheduled or not.

        . unschedule
                Unschedules modules execution from root crontab.


FILES
        $CONF_FILE: configuration file for statfs


VERSION
        $VERSION
EOF
    exit 0
}

start() {
    echo -n "Scheduling modules execution: "

    CMDRET=$(status)
    RETVAL=$?

    if [ $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "Modules execution is already scheduled"
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
    echo -n "Unscheduling modules execution: "

    CMDRET=$(status)
    RETVAL=$?

    if [ ! $RETVAL -eq 0 ]; then
        echo "$RETFAIL"
        echo "Modules execution is not scheduled"
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
    echo -n "Forcing unschedule of modules execution: "

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
        echo "Modules execution is not scheduled"
        return 3
    fi

    IFS_COPY=$IFS
    IFS=$'\n'
    for line in $CRON_BLOCK; do
        CMDRET=$(echo "$CRONRET" | grep "${line//\*/\\*}" | wc -l)
        if [ ! $CMDRET -eq 1 ]; then
            echo "Incorrect configuration found into crontab configuration"
            echo "Try \"$0 force-unschedule\" to correct this"

            RETVAL=3
        fi
    done
    IFS=$IFS_COPY

    if [ ! $RETVAL -eq 0 ]; then
        echo "Modules execution is not scheduled"
    else
        echo "Modules execution is scheduled"
    fi
    return $RETVAL
}

# Create text string to crontab
for i in {0..4}; do
    CRON_BLOCK="${CRON_BLOCK}
${CRON_CFG[$i]} ${UPMOD_BIN} updatefs ${UPMOD_MODES[$i]}"
done

case "$1" in
    schedule)
        checkconf
        start
        ;;
    unschedule)
        checkconf
        stop
        ;;
    force-unschedule)
        checkconf
        forcestop
        ;;
    reschedule)
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

