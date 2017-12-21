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
from subprocess import check_output
from six import print_
from gmpy2 import mpz

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_s(n):
    out = check_output(["primesieve", "7", str(n), "-p1"])
    primes = [int(x) for x in out.split("\n") if len(x)]
    LIM = mpz(1) << ((1 << 12) - 9)
    ret = mpz(4*3*2*1+3*2*1+2+1+1) % 5
    s = []
    m = mpz(2)
    u = 3
    for p in primes:
        q = p-5
        while u <= q:
            m *= u
            if m >= LIM:
                s.append(m)
                m = mpz(1)
            u += 1
        r = mpz('1')
        for x in s:
            r = (r * x) % p
        r *= m
        t = mpz(1)
        v = mpz(1)
        for x in xrange(q+1, p):
            v *= x
            t += v
        ret += ((r * t) % p)
        print_("p = %d ; ret = %d" % (p, ret))
    return ret


def print_s(n):
    print(("S[%d] = %d" % (n, calc_s(n))))
    return


print_s(100)
print_s(100000000)
