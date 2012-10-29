#!/bin/bash
#
# Common variables and functions to statfs
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

readonly VERSION="0.1"

# Default paths
readonly ROOT_PATH="/usr/local"
readonly SHARE_PATH="${ROOT_PATH}/share/statfs"
readonly ETC_PATH="${ROOT_PATH}/etc"
readonly MOD_PATH="${SHARE_PATH}/modules"

# Default files
readonly CONF_FILE="${ETC_PATH}/statfs.cfg"
readonly MANAGER_BIN="${SHARE_PATH}/manager.sh"
readonly UPMOD_BIN="${SHARE_PATH}/upmod.sh"

# Messages returns
readonly RETOK="        [  OK  ]"
readonly RETFAIL="        [ FAIL ]"

# Defaults
RETVAL=0
STATFS_PATH=/usr/local/var
FS_SIZE=50m
MODULES_MIN="example.sh"
MODULES_5MIN=""
MODULES_15MIN=""
MODULES_HOUR=""
MODULES_DAY=""

usage() {
    echo "Usage: $0 $USAGE_PARAMS"
    exit $RETVAL
}

checkconf() {
    # Source configuration file
    if [ ! -r $CONF_FILE ]; then
        echo "The configuration file \"$CONF_FILE\" cannot be found"
        exit 1
    fi

    . $CONF_FILE
}

