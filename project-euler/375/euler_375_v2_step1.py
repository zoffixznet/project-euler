#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

S_0 = 290797
S = S_0
# lookup.
l = {}
i = 0
# One above the maximal modulo.
m = 50515093
while True:
    S = ((S * S) % 50515093)
    m = min([m, S])
    i += 1
    if S in l:
        break
    l[S] = i

print("Repetition starts at %d and ends at %d" % (l[S], i));
print("Minimum is %d" % (m));
