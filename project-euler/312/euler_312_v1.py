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


f = {}
n = 1


def proc(arg):
    global f, n
    if arg in f:
        print_('found n = ', n, ' prev = ', f[arg])
        raise BaseException('f')
    f[arg] = n
    n += 1


MOD = 13 ** 8


def step(pd):
    p, d = pd
    m = ((p*d) << 1)
    return ((m * p) % MOD, (m * d) % MOD)


def main():
    # unittest.main()
    pd = (1, 1)
    pd = (2, 3)
    # init_pd = pd = step(pd)
    init_pd = pd
    global n
    # n = 3
    n = 2
    if False:
        while True:
            pd = step(pd)
            n += 1
            if init_pd == pd:
                print_('Found ', n)

    # C(2) % 13 ** 8 = C(28960856)
    global MOD
    MOD = 28960856 - 2
    if False:
        init_pd = pd = step(pd)
        n += 1
        while True:
            pd = step(pd)
            n += 1
            if init_pd == pd:
                print_('Found ', n)
    # C(3) % 28960854 = C(171369) % 28960854


main()
