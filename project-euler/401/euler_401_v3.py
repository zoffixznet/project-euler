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


def sum_sq(n):
    return ((n * (n+1) * ((n << 1) | 1)) // 6)


def calc_SIGMA2_mod(div, n):
    """docstring for calc_SIGMA2"""
    # MOD = 1000000000
    # MOD = 1000
    # div = 1000000
    sq = 1
    d = 3
    r = 0
    limit = n // (div+1)
    STEP = 100000
    if n % (div+1) == 0:
        pass  # limit -= 1
    for i in xrange(1, limit + 1):
        r += (n // i) * sq
        sq += d
        d += 2
        if i % STEP == 0:
            print("Reached i=%d ret=%d" % (i, r))
            sys.stdout.flush()
    for i in xrange(1, min(div, n)+1):
        top = (n // i)
        bottom = (n // (i+1))
        r += ((sum_sq(top) - sum_sq(bottom)) * i)
        if i % STEP == 0:
            print("FooReached i=%d ret=%d" % (i, r))
            sys.stdout.flush()
    return r


def main():
    for div in xrange(1, 10):
        print("Result = %d" % calc_SIGMA2_mod(div, 1))
        print("Result = %d" % calc_SIGMA2_mod(div, 2))
        print("Result = %d" % calc_SIGMA2_mod(div, 3))
        print("Result = %d" % calc_SIGMA2_mod(div, 4))
        print("Result = %d" % calc_SIGMA2_mod(div, 5))
        print("Result = %d" % calc_SIGMA2_mod(div, 6))
    print("Result = %d" % calc_SIGMA2_mod(1000000, 1000000000000000))


if __name__ == "__main__":
    main()
