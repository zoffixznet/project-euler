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

if sys.version_info > (3,):
    long = int
    xrange = range

L = int(sys.argv.pop(1))
powers = {2: [1], 3: [1]}

for e in [2, 3]:
    while powers[e][-1] < 1000000:
        powers[e].append(powers[e][-1]*e)

p = [[powers[3][i3]*powers[2][i2] for i3 in xrange(len(powers[3]))]
     for i2 in xrange(len(powers[2]))]
for x3 in [len(powers[3])-1]:
    def rec(x, start_y, mysum):
        """docstring for rec"""
        if x == -1:
            print(mysum)
        else:
            rec(x-1, start_y, mysum)
            for y in xrange(start_y, len(powers[2])):
                s = mysum + p[y][x]
                if s >= L:
                    return
                rec(x-1, y+1, s)
        return
    rec(x3, 0, 0)
