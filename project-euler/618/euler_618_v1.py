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

    d = []
    r = 1
    for m in range(n+1):
        if m & 1 == 0:
            d.append(r)
            r = ((r << 1) % BASE)
        else:
            d.append(0)
    for p in primes[1:]:
        print_(token, p)
        for m in range(p, n+1):
            d[m] = ((d[m] + p * d[m-p]) % BASE)
    return d


def main():
    ret = 0
    a, b = 1, 1
    Fk = []
    for k in range(2, 24+1):
        # ret += calc_S(b, str(k))
        Fk.append(b)
        a, b = b, a+b
    ret = calc_S(a, str(a))
    assert ret[8] == 49
    assert ret[1] == 0
    assert ret[2] == 2
    assert ret[3] == 3
    assert ret[5] == 11
    r = sum(ret[x] for x in Fk)
    print_("ret = %d ; %09d" % (r, r % BASE))


main()
