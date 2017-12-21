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


import os
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

MOD = int(os.environ["MOD"])

mods = []

with open('mod_groups.txt') as f:
    for line in f:
        nums = [long(i) for i in line.rstrip('\n').split(' ')]
        count = nums.pop(0)
        for n in nums:
            for i in xrange(count):
                mods.append(n)

my_len = len(mods)
ret = 0


def rec(depth, m, stack):
    if depth == my_len:
        if m == 0:
            global ret
            print(stack)
            ret += 1
    else:
        rec(depth+1, m, stack)
        rec(depth+1, (m+mods[depth]) % MOD, stack + [mods[depth]])
    return


rec(0, 0, [])
ret -= 1
print("Num = %d" % (ret))
