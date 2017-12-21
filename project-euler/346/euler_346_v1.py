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


def find_repunits(m):
    h = {1: True}
    LIM = int(math.sqrt(m))
    for b in xrange(2, LIM+1):
        power = b
        s = 1 + power
        power *= b
        s += power
        while s < m:
            # print "found %d" % s
            h[s] = True
            power *= b
            s += power
    ret = long(0)
    for key in h:
        ret += key
    return ret


def print_repunits(m):
    print("repunits-count(%d) = %d" % (m, find_repunits(m)))
    return


def main():
    print_repunits(50)
    print_repunits(1000)
    print_repunits(int('1' + '0' * 12))


if __name__ == "__main__":
    main()
