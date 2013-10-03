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
import re
import sys
from common import *
from colorcodes import ColorCodes

PROG = sys.argv[0]

def showHelp():
    help = """
[b]USAGE[/]
        %(PROG)s [u]action[/]


[b]DESCRIPTION[/]
        %(PROG)s modules manager.

        This manager provides useful commands to manage statfs modules.


[b]ACTIONS[/]
        . [b]help[/]
                Shows this help screen.

        . [b]show-modules[/]
                Show all available modules.


[b]FILES[/]
        [b]%(CONF_FILE)s[/]: configuration file for statfs


[b]VERSION[/]
        %(VERSION)s
"""
    fmt = { "PROG": PROG, "CONF_FILE": CONF_FILE, "VERSION": VERSION }
    help = help % fmt
    help = ColorCodes().applytags(help)
    print(help)

def availableModules():
    mods = []
    if os.path.isdir(MODS_AVAIL_PATH):
        files = os.listdir(MODS_AVAIL_PATH)
        for f in files:
            ffull = "%s/%s" % (MODS_AVAIL_PATH, f)
            if os.path.isfile(ffull) \
                and os.access(ffull, os.X_OK) \
                and not(re.search(r'~$', f)):
                mods.append(f)
    else:
        sys.stderr.write("Directory \"%s\" does not exist" % MODS_AVAIL_PATH)

    return mods

if len(sys.argv) < 2:
    showHelp()
    sys.exit(1)

opt = sys.argv[1]
if opt == "show-modules":
    mods = availableModules()
    sOut = "Available modules:[b]"
    for m in mods:
        sOut += " %s" % m
    sOut += "[/]"
    print(ColorCodes().applytags(sOut))
elif opt == "help":
    showHelp()
else:
    showHelp()
    sys.exit(1)

# vim: set ts=4 et
