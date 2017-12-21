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
from pybst.avltree import AVLTree
if sys.version_info > (3,):
    long = int


def main():
    primes = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, ]
    t = AVLTree([(x, True) for x in primes])
    s = long(0)
    while True:
        n = t.get_min().key
        t.delete(n)
        for (d, sd) in [(-1, -1), (1, 0)]:
            m = n + d
            while ((m & 0b1) == 0):
                m >>= 1
            for x in primes:
                if m == 1:
                    break
                (d, m_) = divmod(m, x)
                while m_ == 0:
                    m = d
                    (d, m_) = divmod(m, x)
            if m == 1:
                a = n+sd
                s += a
                print("Found s = %d for n = %d" % (s, a))
                sys.stdout.flush()
        for x in primes:
            mul = x * n
            t.insert(mul, True)


main()
