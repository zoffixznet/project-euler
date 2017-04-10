#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

L = int(sys.argv.pop(1))
powers = {2: [1], 3: [1]}

for e in [2, 3]:
    while powers[e][-1] < 1000000:
        powers[e].append(powers[e][-1]*e)

p = [[powers[3][i3]*powers[2][i2] for i3 in xrange(len(powers[3]))]
     for i2 in xrange(len(powers[2]))]
for x3 in [len(powers[3])-1]:
    def rec(x, start_y, mysum):
        """docstring for rec"""
        if x == -1:
            print(mysum)
        else:
            rec(x-1, start_y, mysum)
            for y in xrange(start_y, len(powers[2])):
                s = mysum + p[y][x]
                if s >= L:
                    return
                rec(x-1, y+1, s)
        return
    rec(x3, 0, 0)
