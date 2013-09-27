#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Updater daemon.
#
# Updater daemon that handles, through modules, update for statfs files.
# This daemon is intended to be launched by launcher.py.
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

import sys, time
from daemon import runner
from common import *

if len(sys.argv) != 3:
    print("Exactly two arguments are required")
    sys.exit(1)

sleepSec = sys.argv[2]

class UpMod:
    sleepSec = 1

    def __init__(self, sec):
        self.stdin_path = '/dev/null'
        self.stdout_path = '/dev/tty'
        self.stderr_path = '/dev/tty'
        self.pidfile_path = '%s/upmod_%s.pid' % (PID_PATH, sec)
        self.pidfile_timeout = 5
        self.sleepSec = sec

    def run(self):
        time.sleep(self.sleepSec)

up = UpMod(sleepSec)

daemon_runner = runner.DaemonRunner(up)
daemon_runner.do_action()

# vim: set ts=4 et
