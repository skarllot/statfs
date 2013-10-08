#!/usr/bin/env python
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

import argparse
import commands
import os
import sys
from common import *
from colorcodes import ColorCodes

PROG = os.path.basename(__file__)

def show_help(args):
    help = """\
[b]USAGE[/]
    %(PROG)s [u]action[/]

[b]DESCRIPTION[/]
    %(PROG)s modules manager.
    This manager provides useful commands to manage statfs modules.

[b]ACTIONS[/]
    [b]help[/]            Show this help message.
    [b]show-modules[/]    Show all available modules.

[b]FILES[/]
    [b]%(CONF_FILE)s[/]: configuration file for statfs

[b]VERSION[/]
    %(VERSION)s\
"""
    fmt = { "PROG": PROG, "CONF_FILE": CONF_FILE, "VERSION": VERSION }
    help = help % fmt
    help = ColorCodes().applytags(help)
    print(help)

def get_available_modules():
    mods = {}
    if os.path.isdir(MODS_AVAIL_PATH):
        files = os.listdir(MODS_AVAIL_PATH)
        for f in files:
            ffull = "%s/%s" % (MODS_AVAIL_PATH, f)
            if os.path.isfile(ffull) \
                and os.access(ffull, os.X_OK) \
                and f[-1] != '~':
                (status, output) = commands.getstatusoutput("%s name" % ffull)
                if status:
                    sys.stderr.write("The module '%s' is invalid\n" % f)
                else:
                    mods[f] = output
    else:
        sys.stderr.write("Directory '%s' does not exist\n" % MODS_AVAIL_PATH)

    return mods

def show_avail_mods(args):
    mods = get_available_modules()
    sOut = "Available modules:"
    for m in mods:
        sOut += " [b]%s[/](%s)" % (m, mods[m])
    print(ColorCodes().applytags(sOut))

if len(sys.argv) < 2:
    sys.stderr.write("usage: %s <action>\n" % PROG)
    sys.stderr.write(\
        "%s: error: too few arguments (choose 'help' to show help)\n" % PROG)
    sys.exit(1)

parser = argparse.ArgumentParser(add_help=False)
subparsers = parser.add_subparsers(title="Actions", metavar="")

parser_h = subparsers.add_parser("help")
parser_h.set_defaults(func=show_help)

parser_sm = subparsers.add_parser("show-modules")
parser_sm.set_defaults(func=show_avail_mods)

args = parser.parse_args()
args.func(args)

# vim: set ts=4 et
