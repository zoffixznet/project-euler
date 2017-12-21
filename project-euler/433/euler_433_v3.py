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
from six import print_
# import functools

if sys.version_info > (3,):
    long = int
    xrange = range

c = [[0], [1]]


def E(x, y):
    if y <= 1:
        return y
    if y <= 3000:
        return c[y][x % y]
    return 1 + E(y, x % y)


for y in xrange(2, 3001):
    c.append([])
    arr = c[y]
    for m in xrange(y):
        arr.append(E(y, m)+1)


# @functools.lru_cache(maxsize=128*1024)
def R(x, y):
    return 1+G(y, x % y)


def G(x, y):
    if y <= 1:
        return y
    return R(x, y)


def S(n):
    ret = 0
    # For x == y
    ret += n
    for x in xrange(1, n+1):
        mods = [0, 1]
        for m in xrange(1, x):
            mods.append(mods[-1] + 1 + E(x, m))
        print_("x = %d ; m1 = %d ; m0 = %d" % (x, mods[-1], mods[-1]-x))
        max_ = n - n % x
        t = max_ // x - 1
        delta = t*((mods[-1] << 1))+((mods[n-max_+1]-1) << 1)+n-x
        ret += delta
        if ((x & 0x3FF) == 0):
            print_("x = %d ; ret = %d" % (x, ret))
            sys.stdout.flush()
        if False:
            d = 0
            for y in xrange(x+1, n+1):
                d += E(x, y) + E(y, x)
            print_("x = %d ; d = %d ; delta = %d" % (x, d, delta))
    print_("n = %d ; ret = %d" % (n, ret))
    return ret

#       if False:
#           d = 0
#           for x in xrange(y+1, n+1):
#               d += E(x, y) + E(y, x)
#           print_("y = %d ; d = %d ; delta = %d" % (y, d, delta))


def main():
    S(10)
    S(100)
    S(5000000)


main()
