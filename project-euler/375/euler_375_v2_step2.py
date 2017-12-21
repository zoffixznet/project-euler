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


import sys

if sys.version_info > (3,):
    long = int
    xrange = range

S_0 = 290797
S = S_0


def brute(m):
    s_s = [S_0]
    for i in xrange(1, m+1):
        s_s.append((s_s[-1] * s_s[-1]) % 50515093)

    mysum = long(0)
    for i in xrange(1, m+1):
        for j in xrange(i, m+1):
            mysum += min(s_s[i:(j+1)])

    return mysum


a = []
s = long(0)

# m = 10000
# m = 2000000000
m = 6308949 * 5
st = 1
lim = st
for j in xrange(1, m+1):
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
    n.append({'i': i, 'S': S})
    a = sorted(n, key=lambda t: t['i'])
    for t in xrange(len(a)):
        bottom = (1 if t == 0 else a[t]['i'])
        top = (j if t == len(a)-1 else a[t+1]['i']-1)
        val = (a[t]['S'] if t < len(a) else S)
        s += val * (top - bottom + 1)
    if j == lim:
        lim += st
        print(("M(%d) = %d") % (j, s))
        sys.stdout.flush()

print(("M(%d) = %d") % (m, s))
