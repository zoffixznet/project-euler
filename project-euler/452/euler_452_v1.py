#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def fact(N, x):
    ret = 1
    for i in xrange(N - x):
        ret *= N - i
    return ret


F = []
for x in xrange(1000):
    F.append(fact(x, 0))


def product(lst):
    ret = 1
    for x in lst:
        ret *= x
    return ret


def calc_F(M, N):
    num_non_1 = -1
    ret = 1
    num_non_1 += 1
    num_1 = N - num_non_1 - 1
    ret += fact(N, num_1) * (M - 2 + 1)
    num_non_1 += 1
    while True:
        if ((1 << (1+num_non_1)) > M):
            break
        num_1 = N - num_non_1 - 1
        f1 = fact(N, num_1)

        def rec(prod, counts, top, idx):
            r = 0
            if prod > M:
                return r
            if idx == num_non_1:
                if prod * top <= M:
                    c = list(counts)
                    c[-1] += 1
                    r += f1 // product([F[x] for x in c])
                    d = M // prod
                    if d > top:
                        r += f1 // \
                            product([F[x] for x in counts]) * \
                            (d - top)
                # print_(top, r)
                return r
            c = list(counts)
            c[-1] += 1
            r += rec(prod*top, c, top, idx+1)
            nxt = top+1
            c = counts + [1]
            while True:
                # print_('nxt = ', nxt, r)
                rrec = rec(prod*nxt, c, nxt, idx+1)
                if rrec == 0:
                    break
                r += rrec
                nxt += 1
            return r
        ret += rec(1, [0], 2, 0)
        num_non_1 += 1
        print_('n', num_non_1)
    return ret


def main():
    print_(calc_F(10, 10))
    assert calc_F(10, 10) == 571
    print_(calc_F(10**6, 10**6))
    assert calc_F(10**6, 10**6) % 1234567891 == 252903833
    print_(calc_F(10**9, 10**9) % 1234567891)


main()
