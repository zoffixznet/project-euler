#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
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
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import sys
import re

if sys.version_info > (3,):
    long = int


def main():
    r = re.compile('(000|111|222|333|444|555|666|777|888|999)')
    n = 1
    # total = BigFloat('0')
    total = 0
    step = 100000
    checkpoint = step
    while True:
        n_s = str(n)
        m = r.search(n_s)
        if m:
            n += 10 ** (len(n_s) - m.end(1))
        else:
            # total += BigFloat('1') / n
            total += 1000000000000000000000000000000 / n
            while n > checkpoint:
                print(("n=%030d t = %d") % (n, total))
                sys.stdout.flush()
                checkpoint += step
            n += 1


main()
