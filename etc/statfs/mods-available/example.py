#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
# example   Example module for statfs
#
# description:  Example module for statfs
# param1:       Path for mounted statfs
# param2:       Verbose mode (0=no | 1=yes)

import os
import sys
from datetime import datetime

MOD_NAME = "example"
DEST = "%s/%s" % (sys.argv[1], MOD_NAME)

VERBOSE = False
if len(sys.argv) == 3 and sys.argv[2] == 1:
    VERBOSE = True

if not(os.path.isdir(DEST)):
    if VERBOSE: print("Directory %s cannot be found, creating..." % DEST)
    os.mkdir(DEST)

f = open("%s/update" % DEST, "w")
f.write(str(datetime.now()) + "\n")
f.close()

# vim: set ts=4 et
