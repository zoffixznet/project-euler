#!/usr/bin/env python

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
