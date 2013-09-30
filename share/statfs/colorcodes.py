#!/usr/bin/env python2
# -*- coding: utf-8 -*-
#
# Based on:
# https://gist.github.com/martin-ueding/4007035#file-colorcodes-py
# https://gist.github.com/jyros/5169803#file-colorcodes-py
# https://gist.github.com/housemaister/5255959#file-colorcodes-py
#
# Copyright (c) 2012 Martin Ueding <dev@martin-ueding.de>
# Copyright (c) 2013 Jairo Sanchez <jairoscz@gmail.com>
# Copyright (c) 2013 Stefan Weigand <stefan.weigand@triagnosys.com>
# Copyright (c) 2013 Fabrício Godoy <skarllot@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

import os
import subprocess

class Colorcodes(object):
    """
    Provides ANSI terminal color codes which are gathered via the ``tput``
    utility. That way, they are portable. Color codes are initialized to 
    empty strings.  If the output is being redirected or if there occurs 
    any error with ``tput``, keep empty strings.
    """
    def __init__(self):
        # default to no colorizing
        self.bold = ""
        self.underline = ""
        self.reset = ""

        self.blue = ""
        self.green = ""
        self.orange = ""
        self.red = ""
        self.purple = ""
        self.cyan = ""
        self.white = ""
        self.grey = ""

        # check if redirecting output (i.e. redirecting to a file)
        if os.fstat(0) != os.fstat(1): return

        # try colorizing
        try:
            self.bold = subprocess.check_output("tput bold".split())
            self.underline = subprocess.check_output("tput smul".split())
            self.reset = subprocess.check_output("tput sgr0".split())
 
            self.blue = subprocess.check_output("tput setaf 4".split())
            self.green = subprocess.check_output("tput setaf 2".split())
            self.orange = subprocess.check_output("tput setaf 3".split())
            self.red = subprocess.check_output("tput setaf 1".split())
            self.purple = subprocess.check_output("tput setaf 5".split())
            self.cyan = subprocess.check_output("tput setaf 6".split())
            self.white = subprocess.check_output("tput setaf 7".split())
            self.grey = subprocess.check_output("tput setaf 8".split())
        except subprocess.CalledProcessError as e:
            pass

_c = Colorcodes()

# vim: set ts=4 et
