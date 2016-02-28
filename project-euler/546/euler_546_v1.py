#!/usr/bin/env python3
import math
import sys
if sys.version_info > (3,):
    long = int
    xrange = range


cache = {}
sum_cache = {}
k = 2

def _reset(new_k):
    """reset the cache."""
    global cache, k, sum_cache
    cache = {0:1}
    sum_cache = {(-1):0, 0:1}
    k = new_k
    return

_reset(2)

# s(n) = sum_k=0^k=n(f(k)) = f(0)+f(1)+f(2)...+f(n)
# f(n) = s(n)-s(n-1)
# s(n) = f(kn) / k
# f(n) = [ f(k(n+1)) - f(kn) ] / k
# f(kn) = k * s(n)
# s(kn)-s(kn-1) = k * s(n)
def f(n):
    global cache, k
    if not n in cache:
        # cache[n] = long(sum([f(i/k) for i in xrange(0,n+1)]))
        cache[n] = long(f(n-1)+f(int(n/k)))
    return cache[n]

def my_s(n):
    global sum_cache, k
    if not n in sum_cache:
        # cache[n] = long(sum([f(i/k) for i in xrange(0,n+1)]))
        x = int(n/k)
        sum_cache[n] = long(((my_s(n-1))<<1)-my_s(n-2) + my_s(x)-my_s(x-1))
    return sum_cache[n]

def f(n):
    return my_s(n)-my_s(n-1)

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
