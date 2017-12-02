import math
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


def calc_s(n):
    out = check_output(["primesieve", "2", str(n), "-p1"])
    P = [int(x) for x in out.split("\n") if len(x)]
    ret = (4*3*2*1+3*2*1+2+1+1) % 5
    for i in xrange(3, len(P)):
        p = P[i]
        q = p-5
        r = 1
        hq = q >> 1
        sq = int(math.sqrt(q))
        for j in xrange(0, i):
            t = P[j]
            if t > sq:
                for m in xrange(j, i):
                    t = P[m]
                    if t > hq:
                        for k in xrange(m, i):
                            t = P[k]
                            if t > q:
                                break
                            r *= t
                        break
                    r *= expmod(t, q // t, p)
                break
            r *= expmod(t, calc(q, t), p)
        t = 1
        v = 1
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
