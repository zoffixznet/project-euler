#!/usr/bin/env python
from TAP.Simple import *

from euler_423_v2 import pascal_sum

def check_sum(n, p, val):
    ret = pascal_sum(n, p)
    if not ok (ret == val, "pascal_sum(%d,%d)" % (n,p)):
        diag("got = %d ; expected = %d" % (ret, val))

plan(1)

# TEST
check_sum(2,0,30)
