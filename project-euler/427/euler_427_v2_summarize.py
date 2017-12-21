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
import re
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def main():
    MOD = 1000000009

    def expmod(b, e):
        if e == 0:
            return 1
        r = 1
        if ((e & 1) == 1):
            r *= b
        rec = expmod(b, e >> 1)
        return ((r * rec * rec) % MOD)

    def f(n):
        at_most = [0 for i in xrange(0, n+1)]
        nm = n-1
        at_most[1] = (n * expmod(nm, nm)) % MOD
        at_most[n] = expmod(n, n)

        RE = re.compile('^p = ([0-9]+); ret = (-?[0-9]+)')
        with open('db2.txt') as fh:
            for line in fh:
                m = RE.match(line)
                if not m:
                    raise BaseException("ffoo " + line)
                at_most[int(m.group(1))] = long(m.group(2))
        only = [0 for i in xrange(0, n+1)]
        for len_ in xrange(1, n+1):
            only[len_] = at_most[len_] - at_most[len_-1]
        print_(only[n])
        assert only[n] % MOD == n
        assert only[1] % MOD == at_most[1]

        ret = sum([x*i for i, x in enumerate(only)]) % MOD
        print_('ret = %d' % (ret))
        return ret

    print_(f(7500000))


main()
