#!/usr/bin/env python

import math
import re
import sys
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int
    xrange = range

cache = {"0":long(1)}

def factor_sig(n):
    pipe = Popen(['factor', str(n)], shell=False, stdout=PIPE).stdout
    l = pipe.readline()
    pipe.close()
    sig = {}
    factors_s = re.sub('^[^:]*:', '', l)
    for x in re.findall('[0-9]+', factors_s):
        if not x in sig:
            sig[x] = 0
        sig[x] += 1
    return sorted(sig.values())

def check_factor_sig(n, good):
    if factor_sig(n) != good:
        print ("%d is not good" % (n));
        raise BaseException
    return

check_factor_sig(24, [1, 3]);
check_factor_sig(100, [2, 2]);
check_factor_sig(1000, [3, 3]);
