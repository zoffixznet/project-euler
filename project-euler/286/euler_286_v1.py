#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc(q):
    probs = [1.0]
    for x in xrange(1, 51):
        p = 1 - x / q
        new_probs = []
        for i in xrange(x+1):
            # print("%d %d" % (i,x))
            new_probs.append((0 if (i == x) else probs[i] * (1-p)) +
                             (0 if (i == 0) else (p * probs[i-1])))
        probs = new_probs
    return probs[20]


low = float(50)
high = float(100000)

while True:
    m = ((low + high) / 2)
    v_m = calc(m)
    print("%.40f = %.40f" % (m, v_m))
    if v_m > 0.02:
        low = m
    elif v_m < 0.02:
        high = m
    else:
        break
