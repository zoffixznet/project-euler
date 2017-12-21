#!/usr/bin/env python3

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
if sys.version_info > (3,):
    long = int


k = 2
M = 1000000000 + 7


def _reset(new_k):
    """reset the caches."""
    global k, sum_cache
    sum_cache = {(-1): 0, 0: 1}
    k = new_k
    return


_reset(2)


class MyIter:
    def __init__(self):
        global k
        self.n = 0
        self.f = 1
        # Remaining.
        self.r = 1
        return

    def inc(self):
        global k, M
        self.n += 1
        if self.n < k:
            self.f += 1
        else:
            if self.n == k:
                # Child / sub-iterator
                self.c = MyIter()
            self.r -= 1
            if self.r == 0:
                self.r = k
                self.c.inc()
            self.f += self.c.f
            if self.f > M:
                self.f -= M
        return

    def add(self, delta):
        target = self.n + delta
        while self.n < target:
            self.inc()
        return


f = MyIter()
# STEP
S = 1000000
limit = S
# What we want.
w = 100000000000000
while f.n < w:
    while f.n < limit:
        f.add(10)
    limit += S
    print("f(%d) = %d" % (f.n, f.f))
