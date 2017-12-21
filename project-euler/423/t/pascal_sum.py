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

from TAP.Simple import diag, ok, plan

from euler_423_v2 import pascal_sum


def check_sum(n, p, val):
    ret = pascal_sum(n, p)
    if not ok(ret == val, "pascal_sum(%d,%d)" % (n, p)):
        diag("got = %d ; expected = %d" % (ret, val))


plan(7)

# TEST
check_sum(2, 0, 30)

# TEST
check_sum(2, 1, 6*5+6*1)

# TEST
check_sum(3, 0, 6*5*5)

# TEST
check_sum(3, 1, 6*5*5+6*1*5+6*5*1)

# TEST
check_sum(3, 2, 6*6*6)

# TEST
check_sum(4, 0, 6*5*5*5)

# TEST
check_sum(4, 1, 6*5*5*5+6*1*5*5+6*5*1*5+6*5*5*1)
