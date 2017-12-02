import sys
from subprocess import check_output
from six import print_
from gmpy2 import mpz

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_s(n):
    out = check_output(["primesieve", "7", str(n), "-p1"])
    primes = [int(x) for x in out.split("\n") if len(x)]
    LIM = mpz(1) << ((1 << 12) - 9)
    ret = mpz(4*3*2*1+3*2*1+2+1+1) % 5
    s = []
    m = mpz(2)
    u = 3
    for p in primes:
        q = p-5
        while u <= q:
            m *= u
            if m >= LIM:
                s.append(m)
                m = mpz(1)
            u += 1
        r = mpz('1')
        for x in s:
            r = (r * x) % p
        r *= m
        t = mpz(1)
        v = mpz(1)
        for x in xrange(q+1, p):
            v *= x
            t += v
        ret += ((r * t) % p)
        print_("p = %d ; ret = %d" % (p, ret))
    return ret


def print_s(n):
    print(("S[%d] = %d" % (n, calc_s(n))))
    return


print_s(100)
print_s(100000000)
