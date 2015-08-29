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

def debug_n(n):
    if n > MAX:
        raise "Foobar"
    print "Found[] = ", n

def debug():
    for g in range(bottom+1,top):
        debug_n( g*top )
        debug_n( g*bottom )

# Sum
before_s = -1
s = 0
while before_s < s:
    before_s = s
    l = pipe.stdout.readline()
    top = int(l.rstrip())
    print "top = ", top
    t_sq = top * top
    if top <= SQ:
        debug()
        s += (((top + bottom) * (top + bottom) * (top-bottom-1)) >> 1);
    else:
        r = bottom * (bottom+1)
        while r <= MAX:
            debug_n(r)
            s += r
            r += bottom
    # for g in range(bottom+1,top):
    #    s += g*top
    #    s += g*bottom
    r = (bottom-1) * top
    while r > MAX:
        r -= top
    while r > b_sq:
        debug_n(r)
        s += r
        r -= top
    r = bottom * (top + 1)
    l = min(t_sq-1, MAX)
    while r <= l:
        debug_n(r)
        s += r
        r += bottom
    bottom = top
    b_sq = t_sq

if False:
    d = bottom + 1
    while d*bottom <= MAX or d*top <= MAX:
        if d*bottom <= MAX:
            debug_n(d*bottom)
            s+= d*bottom
        if d*top <= MAX:
            debug_n(d*top)
            s+= d*top
        d += 1

print "s = ", s
