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
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def is_prime(n):
    if n == 1 or ((n & 1) == 0 and n != 2):
        return False
    for d in xrange(3, int(math.sqrt(n))+2, 2):
        if n % d == 0:
            return False
    return True


def rec(MAX_D, d, n, s):
    if is_prime(n // s):
        for x in [1, 3, 7, 9]:
            print(n * 10 + x)
    if d == MAX_D:
        return
    for x in xrange(10):
        new_s = s+x
        new_n = n*10+x
        if new_n % new_s == 0:
            rec(MAX_D, d+1, new_n, new_s)


def main():
    for x in xrange(1, 10):
        rec(13, 1, x, x)


if __name__ == "__main__":
    main()
