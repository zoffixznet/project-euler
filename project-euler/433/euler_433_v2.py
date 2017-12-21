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

if sys.version_info > (3,):
    long = int
    xrange = range

sys.setrecursionlimit(5000004)


# @functools.lru_cache(maxsize=128*1024)
def E(x, y):
    r = 0
    while y != 0:
        r += 1
        x, y = y, x % y
    return r


def S(n):
    lst = [0] + [[0, 0, n % y] for y in xrange(1, n+1)]
    max_ = max([x[-1] for x in lst[1:]])
    print_('max = ', max_)

    def gen(y, x, v):
        if v <= 20:
            print_(y, x, v)
        for q in xrange(y, n+1, x):
            item = lst[q]
            item[0 if x <= item[-1] else 1] += v
            gen(q+x, q, v+1)
    for x in xrange(1, n+1):
        print_(x)
        gen(x << 1, x, 1)
    ret = 0
    # For x == y
    ret += n
    for y in xrange(1, n+1):
        item = lst[y]
        s = item[-1] + item[0]
        ss = s
        s += item[1] + y - item[-1]
        delta = ((ss + s * ((n - y) // y)) << 1) + (n-y)
        ret += delta
        if False:
            d = 0
            for x in xrange(y+1, n+1):
                d += E(x, y) + E(y, x)
            print_("y = %d ; d = %d ; delta = %d" % (y, d, delta))
        if ((y & 0x3FF) == 0):
            print_("y = %d ; ret = %d" % (y, ret))
            sys.stdout.flush()
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
