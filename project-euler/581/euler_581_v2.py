#!/usr/bin/env python
import sys
from pybst.avltree import AVLTree
if sys.version_info > (3,):
    long = int


def main():
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, ]
    t = AVLTree([(long(x), True) for x in primes])
    prev = 1
    s = 0
    while True:
        n = t.get_min().key
        t.delete(n)
        if (n == prev + 1):
            s += prev
            print("Found s = %d for n = %d" % (s, prev))
            sys.stdout.flush()
        for x in primes:
            mul = x * n
            if not t.get_node(mul):
                t.insert(mul, True)
        prev = n


main()
