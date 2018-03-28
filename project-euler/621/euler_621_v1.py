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
# from subprocess import check_output
from six import print_
import heapq
import math

if sys.version_info > (3,):
    long = int
    xrange = range


class MyIter1:
    def __init__(self, n):
        self.n = n
        self.s = (n*(n+1))

    def adv(self):
        self.n += 1
        self.s += self.n


class MyIter2:
    def __init__(self, n, s, m=0):
        self.n = n
        self.s = self.init_s = s
        self.m = m
        self.max = s + ((n*(n+1)-m*(m+1)))

    def skip(self, tgt):
        if tgt > self.max:
            return False
        if tgt == self.s:
            return True
        m = math.floor(math.sqrt(tgt-self.init_s))
        self.m = m
        self.s = self.init_s + ((m*(m+1)))
        if self.s < tgt:
            self.m += 1
            self.s += (m + 1) << 1
        return True

    def adv(self):
        if self.m == self.n:
            return False
        self.m += 1
        self.s += (self.m << 1)
        return True

    def n_inc(self):
        self.n += 1
        self.s += self.n << 1
        self.init_s = self.s
        self.max += (self.n << 2)

    def clone(self):
        return MyIter2(self.n, self.s, self.m)


class IterSumTwo:
    def i(self):
        it = self.it
        return (it.s, it.n, it.clone())

    def __init__(self):
        self.q = []
        self.n = 0
        self.it = MyIter2(0, 0)
        heapq.heappush(self.q, self.i())

    def next(self):
        s, n, i = heapq.heappop(self.q)
        if n == self.n:
            self.n += 1
            self.it.n_inc()
            heapq.heappush(self.q, self.i())
        m = i.m
        if i.adv():
            heapq.heappush(self.q, (i.s, n, i))
        return s, n, m

    def skip(self, tgt):
        new = []
        maxn = 0
        for x in self.q:
            s, n, i = x
            if i.skip(tgt):
                new.append((i.s, n, i))
                if maxn < n:
                    maxn = n
        while self.it.max < tgt:
            self.it.n_inc()
        while self.it.s <= tgt:
            if maxn != self.it.n:
                s, n, i = self.i()
                i.skip(tgt)
                new.append((i.s, n, i))
            self.it.n_inc()
        # print_(cnt)
        heapq.heapify(new)
        self.q = new


PARTS = 10000


def my_find(preM, part):
    M = preM << 1
    m = math.floor(math.sqrt(M))
    high_m = min(m * (part+1) // PARTS - 1, m)
    low_m = m * part // PARTS
    m = high_m
    i = ((m * (m+1)))
    tgt = M-i
    it = IterSumTwo()
    print_("== Solving %d->%d | %d / %d" % (low_m, high_m, part, PARTS))
    while m >= low_m:
        sys.stderr.write(str(('i =', i, m, low_m, tgt)) + "\n")
        it.skip(tgt)
        while True:
            s, n, j = it.next()
            if s > tgt:
                # print_('ss = ', s, tgt)
                break
            n *= n+1
            j *= j+1
            print_("::", sorted([n, j, i]))
        i -= (m << 1)
        tgt += (m << 1)
        m -= 1
    print_("== Finished %d->%d | %d / %d" % (low_m, high_m, part, PARTS))


# my_find(1000)
# my_find(1000000, int(sys.argv[1]))
my_find(17526 * 1000000000, int(sys.argv[1]))


def test_func():
    it = IterSumTwo()
    c = 0
    while c < 128000:
        c += 1
        if True:  # 0 == c & (128 * 1024 - 1):
            print_(it.next())
        else:
            it.next()
