#!/usr/bin/env python
import sys
from heapq import heapify, heappush, heappop
if sys.version_info > (3,):
    long = int


def main():
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, ]
    t = [x for x in primes]
    tset = set(t)
    heapify(t)
    prev = 1
    s = 0
    while True:
        n = heappop(t)
        tset.remove(n)
        if (n == prev + 1):
            s += prev
            print("Found s = %d for n = %d" % (s, prev))
            sys.stdout.flush()
        for x in primes:
            mul = x * n
            if mul not in tset:
                tset.add(mul)
                heappush(t, mul)
        prev = n


main()
