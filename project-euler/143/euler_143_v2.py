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


def main():
    for a in xrange(1, 120000):
        print("a = %d" % (a))
        as_ = a*a
        for b in xrange(1, a+1):
            bs = b*b
            bb = bs - as_
            b4 = -(bb * bb)
            ab = ((as_+bs) << 1)
            for c in xrange(1, b+1):
                cs = c*c
                Z = b4+(cs*(ab-cs))
                if Z < 0:
                    continue
                Z3 = 3 * Z
                zroot = long(math.sqrt(Z3))
                if zroot*zroot != Z3:
                    continue
                an_sq = as_+bs+cs+zroot
                if an_sq & 1:
                    continue
                an_sq >>= 1
                an = long(math.sqrt(an_sq))
                if an > 120000:
                    break
                if an*an != an_sq:
                    continue
                print(an)
                if an == 0:
                    print('0 for a=%d b=%d c=%d' % (a, b, c))


if __name__ == "__main__":
    main()
