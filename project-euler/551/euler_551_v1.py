#!/usr/bin/env python

import math
import re
import sys
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int
    xrange = range

A0 = long(1)

idx = long(1)
a_n = A0

LIM = long(1000000)

while idx < LIM:
    a_n += sum(int(x) for x in str(a_n))
    idx += 1

print (("a[%d] = %d") % (idx, a_n))
