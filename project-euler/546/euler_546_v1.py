#!/usr/bin/env python3
import sys
if sys.version_info > (3,):
    long = int
    xrange = range


sum_cache = {}
k = 2


def _reset(new_k):
    """reset the caches."""
    global k, sum_cache
    sum_cache = {(-1): 0, 0: 1}
    k = new_k
    return


_reset(2)

# s(n) = sum_k=0^k=n(f(k)) = f(0)+f(1)+f(2)...+f(n)
# f(n) = s(n)-s(n-1)
# s(n) = f(kn) / k
# f(n) = [ f(k(n+1)) - f(kn) ] / k
# f(kn) = k * s(n)
# s(kn)-s(kn-1) = k * s(n)
#
# For k=2:
# s(2n) = s(n) + s(n/2) * 2 * n + 2 * n * f(n/2+1) + 2 * (n-2) * f(n/2+2) +
# 2 * (n-4) * f(n/2+3) ... + 2 * f(n) =
# s(2n) = s(n) + s(n/2) * 2 * n + 2 * n * [s(n/2+2)-s(n/2-1)] +
# 2 * (n-2) * [s(n/2+3)-s(n/2+2)] ... + 2 * [s(n+1) - s(n)] =
# s(2n) = s(n) + s(n/2) * 2 * n +


def my_s(n):
    global sum_cache, k
    if n not in sum_cache:
        x = int(n/k)
        sum_cache[n] = long(((my_s(n-1)) << 1)-my_s(n-2) + my_s(x)-my_s(x-1))
    return sum_cache[n]


def f(n):
    return my_s(n)-my_s(n-1)


def calc(new_k, n):
    _reset(new_k)
    for i in range(0, n):
        f(i)
    return f(n)


def is_good(k, n, expected):
    got = calc(k, n)
    if got != expected:
        print("f_%d(%d) = %d != %d" % (k, n, got, expected))
        raise Exception
    return


is_good(5, 10, 18)
is_good(7, 100, 1003)
is_good(2, 1000, long('264830889564'))

for i in range(0, 1000):
    print(("f(%d) = %d") % (i, f(i)))
