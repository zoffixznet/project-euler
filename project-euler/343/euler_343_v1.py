import math
import sys
import functools

if sys.version_info > (3,):
    long = int
    xrange = range


def factor(n):
    # Can never happen in our case:
    # if n == 1:
    #    return []
    ret = []
    f = False
    while (n & 1) == 0:
        # Another domain-specific hack
        return [2]
        f = True
        n >>= 1
    if f:
        ret.append(2)
    limit = int(math.sqrt(n))
    d = 3
    while d <= limit:
        f = False
        while n % d == 0:
            f = True
            n //= d
        if f:
            ret.append(d)
            limit = int(math.sqrt(n))
        d += 2
    if n > 1:
        ret.append(n)
    return ret


def gcd(n, m):
    if m > n:
        n, m = m, n

    while m > 0:
        n, m = m, n % m

    return n


@functools.lru_cache(maxsize=500000)
def cache_calc(x, y):
    return real_calc(x, y)


def real_calc(x, y):
    sum_ = x + y
    f = factor(sum_)
    if f[0] == sum_:
        return sum_ - 1
    d = 1 if (2 == f[0]) else min((l - x % l) for l in f)
    x += d
    y -= d
    g = gcd(x, y)
    return cache_calc(x // g, y // g)


def main():
    r = 0
    for k in xrange(1, 101):
        r += cache_calc(1, k*k*k)
        print("Reached k=%d ret = %d" % (k, r))
    # return
    for k in xrange(101, 2000000+1):
        r += cache_calc(1, k*k*k)
        print("Reached k=%d ret = %d" % (k, r))


if __name__ == "__main__":
    main()
