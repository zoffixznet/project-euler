#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

S_0 = 290797
S = S_0

a = []
s = 0

m = 10
for j in xrange(1,m+1):
    S = ((S * S) % 50515093)
    n = []
    i = j
    for t in a:
        tS = t['S']
        if tS > S:
            if t['i'] < i:
                i = t['i']
        else:
            n.append(t)
    n.append({'i':i,'S':S})
    a = n
    for t in a:
        s += t['S'] * (j-t['i']+1)

print(("M(%d) = %d") % (m, s))
