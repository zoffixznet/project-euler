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
        self.c = None
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
        return

    def clone(self):
        ret = MyIter()
        ret.n = self.n
        ret.f = self.f
        ret.r = self.r
        if self.c:
            ret.c = self.c.clone()
        return ret

    def add(self, delta):
        global k, M, TESTING
        init_f = self.f
        target = self.n + delta
        ret = init_f
        # ret = 0
        while self.r != k and self.n < target:
            self.inc()
            ret += self.f
        target_k = target
        while target_k % k != 0:
            target_k -= 1
        if target_k > self.n:
            k_delta = (target_k - self.n) // k
            k_k_delta = k_delta // k
            if k_k_delta > 0:
                copy = {}
                if TESTING:
                    copy = { 'c':self.clone(), 'ret': ret }
                for i in range(0,k):
                    k_ret = self.c.add(k_k_delta)
                    ret += self.f * k_k_delta + k_ret * k_k_delta
                    self.f += k_ret * k_k_delta
                    self.n += k_k_delta * k
                if TESTING:
                    while copy['c'].n < self.n:
                        copy['c'].inc()
                        copy['ret'] += copy['c'].f
                    copy['ret'] -= copy['c'].f
                    if copy['c'].f != self.f:
                        print ("Good f = %d ; Bad f = %d" % (copy['c'].f, self.f))
                        raise BaseException
                    if copy['ret'] != ret:
                        print ("Good ret = %d ; Bad ret = %d" % (copy['ret'], ret))
                        raise BaseException
        while self.n < target:
            self.inc()
            ret += self.f
        # ret -= self.f
        return ret

f = MyIter()
# STEP
S = 1000
# limit
l = S
# What we want.
w = 1000
while f.n < w:
    while f.n < l:
        new_f = MyIter()
        new_f.add(f.n)
        print ("f(%d) = %d" % (f.n, f.f))
        print ("NEWf(%d) = %d" % (new_f.n, new_f.f))
        f.inc()
    l += S
    print ("f(%d) = %d" % (f.n, f.f))

f = MyIter()
l = S
while f.n < w:
    while f.n < l:
        f.add(1)
    l += S
    print ("f(%d) = %d" % (f.n, f.f))
f = MyIter()
f.add(1000)
print ("f(%d) = %d" % (f.n, f.f))
