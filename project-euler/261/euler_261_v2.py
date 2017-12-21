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

LIM = 10000000000


def find_pivots():
    k = 2
    s_k = 1*1+2*2
    k_m = 1
    STEP = 10000000
    c = STEP
    while k <= LIM:
        if k == c:
            print("Reached %d" % k)
            sys.stdout.flush()
            c += STEP
        n = long(math.sqrt(s_k))
        s_n = n*n
        n_m = n
        ss_k = s_k
        k_mm = k_m
        for m in xrange(2, k+1):
            while s_n > ss_k:
                n_m -= 1
                s_n += n_m*n_m-n*n
                n -= 1
            if n_m <= k:
                break
            if s_n == ss_k:
                print("Found %d" % k)
                sys.stdout.flush()
                break
            k_mm -= 1
            ss_k += k_mm*k_mm
            n += 1
            s_n += n*n
        k += 1
        s_k += k*k-k_m*k_m
        k_m += 1


def main():
    find_pivots()
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
