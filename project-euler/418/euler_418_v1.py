#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

FACTS = [long(1)]
for n in xrange(1, 100):
    FACTS.append(FACTS[-1] * n)

print_(FACTS[10])
N = FACTS[43]
root = long(N ** (1.0 / 3))
print_("root = ", root)
factors = []
start_i = -1
with open('f3.txt') as fh:
    for line in fh:
        n = long(line)
        factors.append(n)
        if start_i < 0 and n > root:
            start_i = len(factors)


def check(i, j):
    fi = factors[i]
    fj = factors[j]
    if N % (fi*fj) == 0:
        fk = N // (fi*fj)
        f_s = sorted([fi, fj, fk])
        print_("Found  ", f_s)
        print_("Sum = %d" % sum(f_s))
        print_("Ratio = %.40f" % (f_s[-1] * 1.0 / f_s[0]))
        return True
    return False


for offset, dir_ in [(-1, -1), (0, 1)]:
    s = start_i + offset
    e = s
    while True:
        i = s
        while i != e:
            if check(i, e):
                break
            i += dir_
        if check(i, e):
            break
        e += dir_
