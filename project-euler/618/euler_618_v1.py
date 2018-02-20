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
from subprocess import check_output
# from six.moves import range

if sys.version_info > (3,):
    long = int


def calc_S(n):
    out = check_output(["primesieve", str(n), "-p1"])
    primes = [long(x) for x in out.decode('ascii').split("\n") if len(x)]

    def rec(i, mysum, myprod):
        p = primes[i]
        if i == 0:
            if mysum % p == 0:
                r = myprod * (p ** (mysum // p))
                print_(r)
                return r
            return 0
        else:
            ret = 0
            while mysum >= 0:
                ret += rec(i-1, mysum, myprod)
                mysum -= p
                myprod *= p
            return ret
    return rec(len(primes)-1, n, 1)


def main():
    print_(calc_S(8))


main()
