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

import os
import sys
import re

NAME = "statfs"
VERSION = "0.2"

SELF_PATH = os.path.dirname(os.path.realpath(__file__))

# Default path
if SELF_PATH == "/usr/share/%s" % (NAME):
    WORK_PATH = "/var/lib/%s" % (NAME)
    SHARE_PATH = "/usr/share/%s" % (NAME)
    PID_PATH = "/var/run/%s" % (NAME)
    ETC_PATH = "/etc/%s" % (NAME)
    STATFS_PATH = "/var/stats"
    CONF_FILE = "%s/%s.conf" % (ETC_PATH, NAME)
# Alternative path
else:
    m = re.search(r'(.+)/share/%s' % (NAME), SELF_PATH)
    if m:
        ROOT_PATH = m.group(1)
        WORK_PATH = "%s/lib/%s" % (ROOT_PATH, NAME)
        SHARE_PATH = "%s/share/%s" % (ROOT_PATH, NAME)
        PID_PATH = "%s/run/%s" % (ROOT_PATH, NAME)
        ETC_PATH = "%s/etc/%s" % (ROOT_PATH, NAME)
        STATFS_PATH = "%s/stats" % (ROOT_PATH)
        CONF_FILE = "%s/%s.conf" % (ETC_PATH, NAME)
    else:
        sys.stderr.write("The file '%s' location is unsupported" % __file__)
        sys.exit(1)

MODS_AVAIL_PATH = "%s/mods-available" % (ETC_PATH)
MODS_ENABLED_PATH = "%s/mods-enabled" % (ETC_PATH)

FS_SIZE = "50m"

# FIXME: Configuration file parsing not implemented
if os.path.isfile(CONF_FILE):
    print("Configuration file parsing not implemented")

# vim: set ts=4 et
