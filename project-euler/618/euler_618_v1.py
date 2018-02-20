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


from six import print_
from subprocess import check_output
# from six.moves import range


def calc_S(n):
    out = check_output(["primesieve", str(n), "-p1"])
    primes = [int(x) for x in out.decode('ascii').split("\n") if len(x)]

    if len(primes) == 0:
        return 0

    caches = [{} for _ in primes]

    def rec(i, mysum):
        p = primes[i]
        if i == 0:
            if mysum % p == 0:
                r = (p ** (mysum // p))
                print_(r)
                return r
            return 0
        else:
            d = caches[i]
            if mysum in d:
                return d[mysum]

            prev_ret = ret = 0
            sub = mysum % p
            while sub <= mysum:
                ret += rec(i-1, sub)
                prev_ret = ret
                ret *= p
                sub += p
            d[mysum] = prev_ret
            return prev_ret
    return rec(len(primes)-1, n)


def main():
    assert calc_S(8) == 49
    assert calc_S(1) == 0
    assert calc_S(2) == 2
    assert calc_S(3) == 3
    assert calc_S(5) == 11
    print_(calc_S(8))


main()
