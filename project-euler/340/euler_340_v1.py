#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

sys.setrecursionlimit(100000)


class F:
    """F"""
    def __init__(self, a, b, c):
        self.a, self.b, self.c = a, b, c
        self.ab = -a + b
        self.ac = a - c

    def f(self, n):
        return self.h(n - self.a)
        if n > self.b:
            return n - self.c
        print_("n=%d" % (n))
        a = self.a

        def g(x):
            return self.f(a + x)
        return g(g(g(g(n))))

    # h(n) = F(a+n)
    # F(n) = h(n-a)
    def h(self, n):
        if n > self.ab:
            return n + self.ac

        def g(x):
            return self.h(x)
        return g(g(g(g(n+self.a))))

    def S(self):
        ret = 0
        for nn in xrange(0, self.b+1):
            n = self.b - nn
            r = self.f(n)
            ret += r
            print_("%d = %d , %d" % (n, r, ret))
        return ret


F(50, 2000, 40).S()
# F(21 ** 7, 7 ** 21, 12 ** 7).S()
