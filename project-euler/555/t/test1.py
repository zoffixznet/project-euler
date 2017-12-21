#!/usr/bin/python

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
from TAP.Simple import diag, is_ok, ok, plan
from euler555 import M_func, S_func

if sys.version_info > (3,):
    long = int

plan(6)


def eq_ok(have, want, blurb):
    ret = ok(have == want, blurb)
    if (not ret):
        diag("(have = '%s', want = '%s')" % (have, want))
    return ret


def main():
    M_91 = M_func(100, 11, 10)

    # TEST
    is_ok(M_91.calc(101), 91, "M[91](101) == 91")

    # TEST
    is_ok(M_91.calc(91), 91, "M[91](91) == 91")

    # TEST
    ok(M_91.calc_F() == [91], "calc_F")

    # TEST
    ok(M_91.calc_SF() == long(91), "calc_SF")

    # TEST
    eq_ok(S_func(10, 10).calc(), long(225), "S(10,10)")

    # TEST
    eq_ok(S_func(1000, 1000).calc(), long(208724467), "S(1000,1000)")


if __name__ == "__main__":
    main()
