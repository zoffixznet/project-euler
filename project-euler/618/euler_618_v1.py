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
from six.moves import range

BASE = 1000000000


def calc_S(n, token='foo'):
    out = check_output(["primesieve", str(n), "-p1"])
    primes = [int(x) for x in out.decode('ascii').split("\n") if len(x)]

    if len(primes) == 0:
        return 0

    pd = []
    r = 1
    for m in range(n+1):
        if m & 1 == 0:
            pd.append(r)
            r = ((r << 1) % BASE)
        else:
            pd.append(0)
    for i in range(1, len(primes)):
        p = primes[i]
        print_(token, i, p)
        d = []
        for m, r in enumerate(pd):
            d.append(r if m < p else ((r + p * d[m-p]) % BASE))
        pd = d
    return pd


def main():
    ret = 0
    a, b = 1, 1
    for k in range(2, 24+1):
        # ret += calc_S(b, str(k))
        a, b = b, a+b
    ret = calc_S(a, str(a))
    assert ret[8] == 49
    assert ret[1] == 0
    assert ret[2] == 2
    assert ret[3] == 3
    assert ret[5] == 11
    print_("ret = %d ; %09d" % (ret[a], ret[a] % BASE))


main()
