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
from functools import reduce
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def gcd(*numbers):
    from fractions import gcd
    return reduce(gcd, numbers)


def lcm(*numbers):
    return reduce((lambda a, b: (a*b) // gcd(a, b)), numbers, 1)


def calc_P(s, N):
    my_lcm = lcm(*list(range(1, s+1)))
    i = my_lcm
    ret = 0
    while i < 1:
        i += my_lcm
    t = s + 1
    while i < N-1:
        if (((i+t) % t) != 0):
            ret += 1
        i += my_lcm
    return ret


def print_P(s, N):
    ret = calc_P(s, N)
    print_("calc_P(s=%d, N=%d) = %d" % (s, N, ret))
    return ret


def main():
    print_P(3, 14)
    print_P(6, 10**6)
    print_P(2, 4**2)
    mysum = 0
    p = long(4)
    for i in xrange(1, 32):
        mysum += print_P(long(i), p)
        print_("mysum(%d) = %d" % (i, mysum))
        p *= 4


if __name__ == "__main__":
    main()
