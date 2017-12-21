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


def calc_lim2_ret(lim2):
    ret = 0
    max_ = int(math.sqrt(lim2))
    for z in xrange(1+max_):
        # print("z=%d l-z=%d" % (z, lim2 - z*z))
        ret += int(math.sqrt(lim2 - z*z))
    return ret


lim2_cache = {}


def lim2_ret(lim2):
    global lim2_cache
    if lim2 not in lim2_cache:
        lim2_cache[lim2] = calc_lim2_ret(lim2)
        # print("InCache")
    return lim2_cache[lim2]


def calc_T(radius):
    x = 0
    shift = 0
    r_sq = radius*radius
    ret = 0
    lim1 = r_sq
    while lim1 >= 0:
        r = 0
        max_ = int(math.sqrt(lim1))
        for y in xrange(1, 1+max_):
            r += lim2_ret(lim1 - y*y)
        ret += ((((r << 1) + lim2_ret(lim1)) << 2) + (max_ << 1) + 1) << shift
        print("x=%d y=%d" % (x, y))
        sys.stdout.flush()
        x += 1
        shift = 1
        lim1 = r_sq-x*x
    return ret


def assert_T(r, want):
    got = calc_T(r)
    print("T(%d) = %d vs %d" % (r, got, want))
    if got != want:
        raise BaseException("fooblead")
    return


def main():
    for lim2 in xrange(10000):
        print("lim2_ret(%d) = %d" % (lim2, calc_lim2_ret(lim2)))
    assert_T(2, 89)
    assert_T(5, 3121)
    assert_T(100, 493490641)
    assert_T(10000, 49348022079085897)
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
