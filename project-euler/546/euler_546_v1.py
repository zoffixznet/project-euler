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
# s(n) = f(k(n+1)-1) / k
# f(n) = [ f(k(n+1)-1) - f(kn-1) ] / k
# f(kn-1) = k * s(n-1)
# s(kn-1)-s(kn-2) = k * s(n-1)
# s(kn)-s(kn-1) = k * s(n-1) + f(n) = k*s(n-1)+s(n)-s(n-1) = (k-1)*s(n-1)+s(n)
# s(kn)-s(kn-2) = (2k-1)s(n-1)+s(n)
# s(kn-2)-s(kn-3) = f(kn-2) = f(kn-1)-f(n-1) = k*s(n-1)-s(n-1)+s(n-2)
#   = (k-1)s(n-1)+s(n-2)
#
# s(0) = 1
# s(1) = s(2*1-1) = 2*s(1-1)+s(2*1-2) = 2*s(0)+s(0) = 3
# s{2}(2) = s(1) + s(0) + s(1) = 3 + 1 + 3 = 7
# f{2}(3) = 1 + 1 + 2 + 2 = 6
# s{2}(3) = s(2*2-3) + s(2*2-1) - s(2*2-3) = 3 + 3*s(1)+s(0) = 13
#
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
    for i in xrange(n):
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

for i in xrange(1000):
    print(("f(%d) = %d") % (i, f(i)))
