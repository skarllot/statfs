#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Common variables and functions to statfs.
#
# Copyright (C) 2013 Fabrício Godoy <skarllot@gmail.com>
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

import sys
import os.path

NAME = "statfs"
VERSION = "0.2"

# Default paths
WORK_PATH = "/var/lib/%s" % (NAME)
SHARE_PATH = "/usr/share/%s" % (NAME)
PID_PATH = "/var/run/%s" % (NAME)
ETC_PATH = "/etc"
MOD_PATH = "%s/modules" % (WORK_PATH)
STATFS_PATH = "/var/stats"

# Default files
CONF_FILE = "%s/%s.conf" % (ETC_PATH, NAME)
D_CONF_FILE = CONF_FILE

if not(os.path.isfile(CONF_FILE)):
    WORK_PATH = "/usr/local/lib/%s" % (NAME)
    SHARE_PATH = "/usr/local/share/%s" % (NAME)
    PID_PATH = "/usr/local/run/%s" % (NAME)
    ETC_PATH = "/usr/local/etc"
    MOD_PATH = "%s/modules" % (WORK_PATH)
    STATFS_PATH = "/usr/local/stats"
    CONF_FILE = "%s/%s.conf" % (ETC_PATH, NAME)


if not(os.path.isfile(CONF_FILE)):
    print("The configuration file \"%s\" cannot be found" % (D_CONF_FILE))
    sys.exit(1)

FS_TYPE = "50m"
MODULES = [ [ 60, [ "example.sh" ] ], [ 300, [ ] ], [ 900, [ ] ] ]

# FIXME: Configuration file parsing not implemented
print("Configuration file parsing not implemented")

# vim: set ts=4 et
