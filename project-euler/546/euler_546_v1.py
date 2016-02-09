#!/usr/bin/env python3
import math
import sys
if sys.version_info > (3,):
    long = int
    xrange = range


cache = {}
k = 2

def _reset(new_k):
    """reset the cache."""
    global cache
    global k
    cache = {0:1}
    k = new_k
    return

_reset(2)

def f(n):
    global cache, k
    if not n in cache:
        # cache[n] = long(sum([f(i/k) for i in xrange(0,n+1)]))
        cache[n] = long(f(n-1)+f(int(n/k)))
    return cache[n]

def calc(new_k, n):
    _reset(new_k)
    for i in range(0,n):
        f(i)
    return f(n)

def is_good(k, n, expected):
    got = calc(k, n)
    if got != expected:
        print ("f_%d(%d) = %d != %d" % (k, n, got, expected))
        raise Exception
    return

is_good(5, 10, 18)
is_good(7, 100, 1003)
is_good(2, 1000, long('264830889564'))
