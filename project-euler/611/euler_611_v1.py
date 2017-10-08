#!/usr/bin/env python

import heapq
import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def solve_for(n):
    def gen_sq():
        sq = 1
        d1, d2 = 3, 5
        sq2 = sq + d1
        sum_sq = sq + sq2
        while sum_sq <= n:
            yield (sum_sq, d2)
            sq, sq2 = sq2, sq2 + d2
            sum_sq = sq + sq2
            d2 += 2
        yield (n+1, n+1)
    gen = gen_sq()
    pq = []
    heapq.heappush(pq, next(gen))
    last = -1
    count = 0
    ret = 0
    pivot_sq, pivot_d = next(gen)
    while pivot_sq <= n:
        heapq.heappush(pq, (pivot_sq, pivot_d))
        pivot_sq, pivot_d = next(gen)
    while len(pq) > 0:
        this, d = heapq.heappop(pq)
        if this != last:
            if count == 1:
                ret += 1
                if ((ret & 0x3FFFF) == 0):
                    print_("Reached %d" % (this))
            count = 0
            last = this
        count ^= 1
        new = this+d
        if new <= n:
            heapq.heappush(pq, (new, d+2))
    if count == 1:
        ret += 1
    return ret


def p(n):
    print_("F(%d) = %d" % (n, solve_for(n)))


def main():
    p(5)
    p(100)
    p(1000)
    p(1000000)
    p(1000000000000)


main()
