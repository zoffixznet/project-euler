#!/usr/bin/env python

import sys
from six import print_
from collections import deque

if sys.version_info > (3,):
    long = int
    xrange = range


def count(n, p):
    if p > n:
        return 0
    return n // p + count(n // p, p)


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

        for len_m in xrange(2, n):
            len_ = n+1-len_m
            s = n
            if (((len_-1) << 1) > n):
                low_s = s * nm % MOD
                s = s * expmod(n, len_) % MOD
                s = (s - n) % MOD
                e = n-len_-1
                if e > 0:
                    s = (s * expmod(n, e) - low_s * e * expmod(n, e-1)) % MOD
                # state[0] = n
                # state[i] = nm * n ** i for i <= len_
                # state[e+len_-1] = s * n ** e - low_s * e * n ** (e-1)
                #           for e <= len_-1
                # state[2l-2+1] =

            else:
                state = deque([n])
                for pos in xrange(2, len_+1):
                    t = s
                    s *= nm
                    state.append(s % MOD)
                    s = ((s + t) % MOD)
                for pos in xrange(len_+1, n+1):
                    t = s
                    s *= nm
                    state.append(s % MOD)
                    s = ((s + t - state.popleft()) % MOD)
                # print_('p = %d ; pos_ = %d' % (len_, pos))
            at_most[len_] = s
            print_('p = %d ; ret = %d' % (len_, at_most[len_]))
            sys.stdout.flush()
        only = [0 for i in xrange(0, n+1)]
        for len_ in xrange(1, n+1):
            only[len_] = at_most[len_] - at_most[len_-1]
        assert only[n] == n
        assert only[1] % MOD == at_most[1]

        ret = sum([x*i for i, x in enumerate(only)]) % MOD
        print_('ret = %d' % (ret))
        return ret

    assert f(3) == 45
    assert f(7) == 1403689
    assert f(11) == 481496895121 % MOD
    print_(f(7500000))


main()
