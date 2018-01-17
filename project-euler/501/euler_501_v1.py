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


import math
import os
import sys
import re
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def count_primes(N):
    out = os.popen('primesieve -c 2 %d' % (N)).read()
    m = re.search(r'Primes\s*:\s*([0-9]+)', out)
    return int(m.group(1))


def calc_nums_of_eight_divisors(N):
    # First of all x ** 7
    ret = 0
    ret += count_primes(int(math.pow(N, 1.0/7)))


def main():
    print_("Foo")


main()


#        if True:
#            good = 0
#            want = []
#            for y in xrange(M+1, N+1):
#                if (((y*y // (x*x)) & 1) == 1):
#                    want.append(y)
#                    good += 1
#            if good != r:
#                print_(x, good, r)
#            # assert good == r
