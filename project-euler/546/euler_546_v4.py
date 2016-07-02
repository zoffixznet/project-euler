#!/usr/bin/env python3
import sys
if sys.version_info > (3,):
    long = int
    xrange = range


k = 2
M = 1000000000 + 7
TESTING = True

def _reset(new_k):
    """reset the caches."""
    global k
    k = new_k
    return

_reset(2)

class MyIter:
    def __init__(self):
        self.n = 0
        self.f = long(1)
        # Remaining.
        self.r = 1
        return

    def is_pristine(self):
        """is pristine"""
        return (self.n == 0)

    def clone(self):
        ret = MyIter()
        ret.n = self.n
        ret.f = self.f
        ret.r = self.r
        return ret

def inc(arr, idx):
    self = arr[idx]
    global k, M
    self.n += 1
    if self.n < k:
        self.f += 1
    else:
        self.r -= 1
        if self.r == 0:
            self.r = k
            inc(arr, idx+1)
        self.f += arr[idx+1].f
    return

f = [MyIter() for x in xrange(0,1000)]
# STEP
S = 1
# limit
l = S
# What we want.
w = 1000
while f[0].n < w:
    while f[0].n < l:
        inc(f,0)
    l += S
    # Print the state.
    t = []
    idx = 0
    while not f[idx].is_pristine():
        t.append(f[idx])
        idx += 1
    print ("f(%d) = %s" % (f[0].n, ",".join(["{n=%d;f=%d;r=%d}" % (x.n,x.f,x.r) for x in t])))

