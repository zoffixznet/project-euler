#!/usr/bin/env python

import sys
import unittest
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range
sys.setrecursionlimit(20005)


def paths_count(n, MOD):
    if n == 1:
        return (1, 1)
    if n == 2:
        return (2, 3)
    p, d = paths_count(n-1, MOD)
    m = ((p*d) << 1)
    return ((m * p) % MOD, (m * d) % MOD)


def C(n, MOD):
    if n <= 2:
        return 1
    return ((paths_count(n-1, MOD)[0] ** 3) % MOD)


class FooTestCase(unittest.TestCase):
    def testC(self):
        self.assertEqual(C(3, 10**100), 8)
        self.assertEqual(C(5, 10**100), 71328803586048)
        self.assertEqual(C(10000, 13 ** 8), 617720485)


def main():
    unittest.main()
    print_('Foo')


main()
