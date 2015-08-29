#!/usr/bin/env python

import subprocess
import sys
import math

MAX = int(sys.argv[1])

SQ = int(math.sqrt(float(MAX)))

pipe = subprocess.Popen(['primes', '3'], shell=False, stdout=subprocess.PIPE)

bottom = 2
b_sq = bottom * bottom
top = -1
t_sq = -1
def debug():
    for g in range(bottom+1,top):
        print g*top
        print g*bottom

# Sum
s = 0
while True:
    l = pipe.stdout.readline()
    top = int(l.rstrip())
    print "top = ", top
    if top > SQ:
        break;
    debug()
    s += (((top + bottom) * (top-1 + bottom-1) * (top-bottom-1)) >> 1);
    t_sq = top * top
    r = (bottom-1) * top
    while r > b_sq:
        s += r
        r -= top
    r = bottom * top + 1
    while r < t_sq:
        s += r
        r += bottom
    bottom = top
    b_sq = t_sq

d = bottom + 1
while d*bottom <= MAX or d*top <= MAX:
    if d*bottom <= MAX:
        s+= d*bottom
    if d*top <= MAX:
        s+= d*top
    d += 1

print "s = ", s
