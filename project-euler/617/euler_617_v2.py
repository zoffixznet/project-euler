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


def calc_D(N):
    ret = 0
    for e in xrange(2, N):
        max_a = long(N ** (1.0/e))
        while max_a ** e + max_a > N:
            max_a -= 1
        if max_a <= 1:
            break
        print_("count(N=%d, e=%d) = %d" % (N, e, max_a-1))
        ret += max_a - 1
    print_("D(N=%d) = %d" % (N, ret))
    return ret


D = 0
n = 6
L = 3
NL = 1 << L


def main():
    calc_D(10)
    calc_D(100)
    calc_D(1000)
    calc_D(1000000)
    calc_D(1000000000000)
    calc_D(1000000000000000000)


main()
