#!/usr/bin/env python3
import sys
if sys.version_info > (3,):
    long = int
    xrange = range


k = 2


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
        self.f = long(1)
        # Remaining.
        self.r = 1
        return

    def inc(self):
        global k
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

f = MyIter()
STEP = 1
lim = STEP
w = 100000000000000
while f.n < w:
    while f.n < lim:
        f.inc()
    lim += STEP
    print ("f(%d) = %d" % (f.n, f.f))
