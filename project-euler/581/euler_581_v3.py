#!/usr/bin/env python
import math
import sys
from pybst.avltree import AVLTree
if sys.version_info > (3,):
    long = int


def main():
    primes = [ 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, ];
    t = AVLTree([(x,True) for x in primes])
    s = long(0)
    while True:
        n = t.get_min().key
        t.delete(n)
        for (d,sd) in [(-1,-1),(1,0)]:
            m = n + d
            while ((m & 0b1) == 0):
                m >>= 1
            for x in primes:
                if m == 1:
                    break
                (d,m_)=divmod(m,x)
                while m_ == 0:
                    m = d
                    (d,m_)=divmod(m,x)
            if m == 1:
                a = n+sd
                s += a
                print("Found s = %d for n = %d" % (s, a))
                sys.stdout.flush()
        for x in primes:
            mul = x * n
            t.insert(mul,True)


main()

