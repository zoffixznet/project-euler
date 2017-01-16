#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

A0 = long(1)

idx = long(1)
a_n = A0

LIM = long(1000000)


def _print_me():
    global idx, a_n
    print(("a[%d] = %d") % (idx, a_n))


while idx < LIM:
    _print_me()
    a_n += sum(int(x) for x in str(a_n))
    idx += 1

_print_me()
