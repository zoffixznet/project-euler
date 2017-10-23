#!/usr/bin/env python

import subprocess
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

pipe = subprocess.Popen(['primes', '2', '1000000'], shell=False,
                        stdout=subprocess.PIPE)
primes = {}
line = pipe.stdout.readline()
while line:
    primes[int(line.rstrip())] = 0
    line = pipe.stdout.readline()

L = int(sys.argv.pop(1))
powers = {2: [1], 3: [1]}

for e in [2, 3]:
    while powers[e][-1] < 1000000:
        powers[e].append(powers[e][-1]*e)

p = [[powers[3][i3]*powers[2][i2] for i3 in xrange(len(powers[3]))]
     for i2 in xrange(len(powers[2]))]


def rec(x, start_y, mysum):
    if x == -1:
        if mysum in primes:
            primes[mysum] += 1
    else:
        rec(x-1, start_y, mysum)
        for y in xrange(start_y, len(powers[2])):
            s = mysum + p[y][x]
            if s >= L:
                return
            rec(x-1, y+1, s)
    return


rec(len(powers[3])-1, 0, 0)

mysum = 0
for p, count in primes.iteritems():
    if count == 1:
        mysum += p

print(mysum)
