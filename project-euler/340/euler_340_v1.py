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
