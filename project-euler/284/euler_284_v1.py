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
from gmpy2 import mpz

if sys.version_info > (3,):
    long = int
    xrange = range

BASE = 14
powers = [mpz(1)]
for n in xrange(1, 10001):
    powers.append(powers[-1] * BASE)

MP = [[p * d for d in xrange(0, BASE)] for p in powers]

MAX = 9


def rec(n, sq, is_z, digits_sum):
    # print_('sq =', sq)
    s = [[sq, is_z, digits_sum, 0]]
    ret = 0
    while len(s):
        # if len(s) & 0xFF == 0:
        #     print_('n =', len(s))
        if len(s) > MAX+1:
            s.pop()
            continue
        sq, is_z, digits_sum, d = s[-1]
        if (((sq*sq) % powers[len(s)-1]) != sq):
            s.pop()
            continue
        if sq == 0 and len(s) > 3:
            s.pop()
            continue
        if d == 0:
            if not is_z:
                ret += digits_sum
        elif d == BASE:
            s.pop()
            continue
        s[-1][-1] += 1
        s.append([sq+MP[len(s)-1][d], (d == 0), digits_sum+d, 0])
    return ret


# print_(rec(0, long(0), True, 0))
MAX = 10000
print_(rec(0, mpz(0), True, 0))
