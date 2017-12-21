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


def exp15(b, MOD):
    r = ((b * b * b * b * b) % MOD)
    return ((r * r * r) % MOD)


def main():
    LIM = 100000000000
    with open('primes.txt') as in_:
        for l in in_:
            p = int(l)
            q = p - 1
            m = LIM % p
            c1 = 0
            for i in xrange(1, m+1):
                if exp15(i, p) == q:
                    # print("Found %d for %d" % (i, p))
                    c1 += 1
            c = c1
            for i in xrange(m+1, p):
                if exp15(i, p) == q:
                    # print("Found %d for %d" % (i, p))
                    c += 1
            print("R = %d for %d" % ((((LIM // p) * c + c1) * p), p))


if __name__ == "__main__":
    main()
