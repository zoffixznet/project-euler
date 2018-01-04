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
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_C(N, LOG):
    def is_e(e):
        ret = 0
        for a0 in xrange(2, N):
            an = a0 ** e
            if an >= N:
                return ret
            found = {a0: True}
            a = min(an, N-an)
            so_far = [a0, a]
            while a > 1:
                if a in found:
                    ret += 1
                    print_("N = %d ; e = %d ;" % (N, e), so_far)
                    break
                found[a] = True
                an = a ** e
                a = min(an, N-an)
                so_far.append(a)
        assert False
    ret = 0
    for e in xrange(2, LOG):
        ret += is_e(e)
    return ret


def calc_D(N):
    ret = 0
    for e_base in xrange(2, N):
        to_break = False
        L = {}
        for fact in xrange(1, N):
            e2 = e_base**fact
            for sub_fact in xrange(0, fact):
                sub_e = e_base ** sub_fact
                e = e2
                max_a = long(N ** (1.0/e))
                sub_a = max_a ** sub_e
                while max_a ** e + sub_a > N:
                    max_a -= 1
                    sub_a = max_a ** sub_e
                if max_a <= 1:
                    to_break = (sub_fact == 0)
                    break
                r = 0
                if e == 2:
                    print_("Foo")
                    r += max_a - 1
                else:
                    for base_a in xrange(2, max_a+1):
                        for sf in xrange(0, fact):
                            se = e_base ** sf
                            a0 = base_a ** se
                            n = base_a ** e + base_a ** sub_e
                            if e_base == 2 and a0 * a0 + a0 == n:
                                continue
                            key = (n, a0)
                            if key in L:
                                continue
                            L[key] = True
                            r += 1
                print_("count(N=%d, e=%d, factor=%d, sub_fact=%d) = %d" %
                       (N, e_base, fact, sub_fact, r))
                ret += r
            if to_break:
                to_break = (fact == 1)
                break
        if to_break:
            break
    print_("D(N=%d) = %d" % (N, ret))
    return ret


D = 0
n = 6
L = 3
NL = 1 << L


def main():
    calc_D(1000)
    if False:
        calc_D(10)
        calc_D(100)
        calc_D(1000000)
    calc_D(1000000000000)
    calc_D(1000000000000000000)


main()
