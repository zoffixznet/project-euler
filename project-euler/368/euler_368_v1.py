#!/usr/bin/env python

import sys
import re
from bigfloat import precision

if sys.version_info > (3,):
    long = int
    xrange = range

with precision(60):
    r = re.compile('(000|111|222|333|444|555|666|777|888|999)')
    n = 1
    # total = BigFloat('0')
    total = 0.0
    step = 100000
    checkpoint = step
    while True:
        n_s = str(n)
        m = r.search(n_s)
        if m:
            n += int('1' + '0' * (len(n_s) - m.end(1)))
        else:
            # total += BigFloat('1') / n
            total += 1.0 / n
            while n > checkpoint:
                print(("n=%030d t = %.40f") % (n, total))
                sys.stdout.flush()
                checkpoint += step
            n += 1
