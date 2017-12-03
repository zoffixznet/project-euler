import sys
from subprocess import check_output
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def calc(n, d):
    if n < d:
        return 0
    m = n // d
    return m + calc(m, d)


def expmod(b, e, M):
    if e == 0:
        return 1
    rec = expmod(b, e >> 1, M)
    return (((b if ((e & 1) == 1) else 1) * rec * rec) % M)


# These routines were taken from
# http://rosettacode.org/wiki/Chinese_remainder_theorem#Python - thanks!
def chinese_remainder(n, a):
    s = 0
    prod = 1
    for x in n:
        prod *= x

    for n_i, a_i in zip(n, a):
        p = prod / n_i
        s += a_i * mul_inv(p, n_i) * p
    return s  # % prod


def mul_inv(a, b):
    b0 = b
    x0, x1 = 0, 1
    if b == 1:
        return 1
    while a > 1:
        q = a / b
        a, b = b, a % b
        x0, x1 = x1 - q * x0, x0
    if x1 < 0:
        x1 += b0
    return x1


def calc_s(n):
    out = check_output(["primesieve", "7", str(n), "-p1"])
    primes = [int(x) for x in out.split("\n") if len(x)]
    ret = (4*3*2*1+3*2*1+2+1+1) % 5
    # print_("p = %d ; ret = %d" % (0, ret))
    for p in primes:
        r = p
        v = 1
        for x in xrange(2, 5):
            v = chinese_remainder([p, p-x], [v, 0]) // (p-x)
            r += v
        ret += r % p
        print_("p = %d ; ret = %d" % (p, ret))
    return ret


def print_s(n):
    print(("S[%d] = %d" % (n, calc_s(n))))
    return


print_s(100)
print_s(100000000)
