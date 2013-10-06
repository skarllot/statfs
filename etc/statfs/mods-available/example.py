#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# description:  Example module for statfs

import argparse
import os
import sys
from datetime import datetime

MOD_NAME = "example"

def update(args):
    path = args.directory
    if not(os.path.isdir(path)):
        sys.stderr.write("Directory '%s' cannot be found\n" % path)
        sys.exit(1)

    fname = "%s/update" % path
    if args.verbose:
        if not(os.path.isfile(fname)):
            print("File '%s' does not exist, will be created" % fname)

    f = open(fname, "w")
    f.write(str(datetime.now()) + "\n")
    f.close()

def show_frequency(args):
    print("60")

def show_dependencies(args):
    print("")

def show_name(args):
    print(MOD_NAME)

parser = argparse.ArgumentParser(description="Example module for statfs", formatter_class=lambda prog: argparse.HelpFormatter(prog,max_help_position=80))
subparsers = parser.add_subparsers(title="Actions", metavar="")

parser_f = subparsers.add_parser("default-frequency", \
    help="gets default update frequency (in seconds)")
parser_f.set_defaults(func=show_frequency)

parser_d = subparsers.add_parser("dependencies", \
    help="returns which modules this module depends")
parser_d.set_defaults(func=show_dependencies)

parser_n = subparsers.add_parser("name", \
    help="returns this module name")
parser_n.set_defaults(func=show_name)

parser_u = subparsers.add_parser("update", \
    help="updates info provided by this module")
parser_u.add_argument("directory", type=os.path.abspath, \
    help="path to mounted statfs")
parser_u.add_argument("-v", "--verbose", action="store_true", \
    help="verbose output")
parser_u.set_defaults(func=update)

args = parser.parse_args()
args.func(args)

# vim: set ts=4 et
