#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Manager to launch modules updater daemons.
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
import commands
from common import *

cmd='python upmod.py start'
(status, output) = commands.getstatusoutput(cmd)
if status:
    sys.stderr.write(output)
    sys.exit(1)

# vim: set ts=4 et
