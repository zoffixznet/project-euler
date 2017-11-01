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
    pd = paths_count(2, MOD)
    for i in xrange(3, n+1):
        pd = step(pd, MOD)
    return pd


def C(n, MOD):
    if n <= 2:
        return 1
    return ((paths_count(n-1, MOD)[0] ** 3) % MOD)


class FooTestCase(unittest.TestCase):
    def testC(self):
        self.assertEqual(C(3, 10**100), 8)
        self.assertEqual(C(5, 10**100), 71328803586048)
        self.assertEqual(C(10000, 13 ** 8), 617720485)
        self.assertEqual(C(10000, 10 ** 8), 37652224)


def step((p, d), MOD):
    m = ((p*d) << 1)
    return ((m * p) % MOD, (m * d) % MOD)


def main():
    # unittest.main()
    MOD = 13 ** 8
    init_pd = pd = (2, 3)
    n = 2
    if True:
        while True:
            pd = step(pd, MOD)
            n += 1
            if init_pd == pd:
                print_('Found ', n)
                break

    # C(2) % 13 ** 8 = C(28960856)
    MOD = 28960856 - 2
    if True:
        pd = (2, 3)
        n = 2
        init_pd = pd = step(pd, MOD)
        n += 1
        while True:
            pd = step(pd, MOD)
            n += 1
            if init_pd == pd:
                print_('Found ', n)
                break

    # C(3) % 28960854 = C(171369) % 28960854
    C1 = C(10000, 171369-3)
    print_(C1)
    C2 = C(C1, 28960854)
    print_(C2)
    C3 = C(C2, 13 ** 8)
    print_(C3)


main()
