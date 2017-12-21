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


def calc_SIGMA2_mod(MOD, n):
    """docstring for calc_SIGMA2"""
    # MOD = 1000000000
    # MOD = 1000
    sq = 1
    d = 3
    r = 0
    for i in xrange(1, min(MOD, n+1)):
        if sq != 0:
            j = i
            jdiv = n // j
            t = 0
            while jdiv > 1:
                t += jdiv
                j += MOD
                jdiv = n // j
            t_diff = ((1 + (n - j) // MOD) if j <= n else 0)
            r = ((r + sq * (t + t_diff)) % MOD)
        sq = ((sq+d) % MOD)
        d += 2
        print("Reached i=%d ret=%d" % (i, r))
        sys.stdout.flush()
    return r


def main():
    print("Result = %d" % calc_SIGMA2_mod(1000, 1))
    print("Result = %d" % calc_SIGMA2_mod(1000, 2))
    print("Result = %d" % calc_SIGMA2_mod(1000, 3))
    print("Result = %d" % calc_SIGMA2_mod(1000, 4))
    print("Result = %d" % calc_SIGMA2_mod(1000, 5))
    print("Result = %d" % calc_SIGMA2_mod(1000, 6))
    print("Result = %d" % calc_SIGMA2_mod(1000000000, 1000000000000000))


if __name__ == "__main__":
    main()
