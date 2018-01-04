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


def calc_C(N, LOG):
    def is_e(e):
        ret = 0
        for a0 in xrange(2, N):
            an = a0 ** e
            if an >= N:
                return ret
            found = {a0: True}
            a = min(an, N-an)
            so_far = [a0, a]
            while a > 1:
                if a in found:
                    ret += 1
                    print_("N = %d ; e = %d ;" % (N, e), so_far)
                    break
                found[a] = True
                an = a ** e
                a = min(an, N-an)
                so_far.append(a)
        assert False
    ret = 0
    for e in xrange(2, LOG):
        ret += is_e(e)
    return ret


D = 0
n = 6
L = 3
NL = 1 << L


def main():
    def upto(N):
        global n, D, L, NL
        while n <= N:
            D += calc_C(n, L)
            if (n & 0xFFFF) == 0:
                print_("D(%d) = %d" % (n, D))
            n += 1
            if n == NL:
                L += 1
                NL = 1 << L
        print_("D(%d) = %d" % (N, D))
    upto(10)
    upto(100)
    upto(1000)
    upto(1000000)


main()
