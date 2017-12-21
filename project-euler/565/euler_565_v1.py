#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import math
import subprocess
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

# MAX = 1000000000
# MAX = 1000000
MAX = 100000000000
MOD = 2017

root = int(math.sqrt(MAX))
p1 = subprocess.Popen(["primes", "2", str(root)], stdout=subprocess.PIPE)

while True:
    line = p1.stdout.readline()
    if line == '':
        break
    n = int(line)
    nn = n
    sum_ = 1 + nn
    while nn <= MAX:
        if (sum_ % MOD == 0):
            prod = nn
            while prod <= MAX:
                for i in xrange(1, n):
                    if prod <= MAX:
                        print(prod)
                    else:
                        prod += nn
                        break
                    prod += nn
                prod += nn
        nn *= n
        sum_ += nn


def is_prime(n):
    for x in xrange(3, int(math.sqrt(n))+1, 2):
        if n % x == 0:
            return False
    return True


m2 = MOD * 2
start = root + m2 - (root % m2)

for n in xrange(start-1, MAX+1, m2):
    if is_prime(n):
        for nn in xrange(n, MAX+1, n):
            print(nn)
