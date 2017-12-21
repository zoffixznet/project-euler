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


def x(n):
    if n < 2:
        return n
    k = (n >> 1)
    x_k = x(k)
    x_half = x(k >> 1)
    return (((x_k << 1) + 3*(x_half) if (n & 0x1) == 1
            else (3*x_k + (x_half << 1))) & ((1 << 60) - 1))


def y(n, k):
    if k >= n:
        return x(k)
    k2 = (k << 1)
    return (((1 << 60) - 1) - max(y(n, k2), y(n, (k2 | 0x1))))


def A(n):
    return y(n, 1)


def ass_y(n, k, expected):
    got = y(n, k)
    if (got != expected):
        print("y(%d,%d) = %d != %d" % (n, k, got, expected))
        raise BaseException
    return


def ass_A(n, expected):
    got = A(n)
    if (got != expected):
        print("A(%d) = %d != %d" % (n, got, expected))
        raise BaseException
    return


ass_y(4, 4, 11)
ass_y(4, 3, ((1 << 60)-9))
ass_y(4, 2, ((1 << 60)-12))
ass_y(4, 1, 8)
ass_A(10, ((1 << 60)-34))
ass_A(1000, 101881)
