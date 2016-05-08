from fractions import Fraction
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def find_M(p, lim):
    s = Fraction(long(1), long(1))
    for k in xrange(2, p):
        s += Fraction(1, k)

    M = 0
    n = long(p-1)
    while True:
        if s.denominator % p != 0:
            M = n
        print("Found M=%d for n=%d" % (M, n))
        d = Fraction(0, 1)
        for k in xrange(n+1, n+p+1):
            d += Fraction(1, k)
        n += p
        s += d

find_M(long(sys.argv[1]), 0)
