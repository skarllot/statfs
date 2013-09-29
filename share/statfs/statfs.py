#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
# STATFS manager.
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
from common import *

def showHelp():
    print("HELP")

def availableModules():
    if os.path.isdir(MODS_AVAIL_PATH):
        sOut = "Available modules:"
        files = os.listdir(MODS_AVAIL_PATH)
        for f in files:
            ffull = "%s/%s" % (MODS_AVAIL_PATH, f)
            if os.path.isfile(ffull) and os.access(ffull, os.X_OK):
                sOut += " %s" % f
        print(sOut)
    else:
        sys.stderr.write("Directory \"%s\" does not exist" % MODS_AVAIL_PATH)

if len(sys.argv) < 2:
    showHelp()
    sys.exit(1)

if sys.argv[1] == "show-modules":
    availableModules()
else:
    showHelp()
    sys.exit(1)

# vim: set ts=4 et
