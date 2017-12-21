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


def main():
    primes = []
    with open('primes.txt') as f:
        for l in f:
            primes.append(long(l))
    # print(primes)
    LIM = 10000000
    # LIM = 100
    ret = long(0)
    for p_idx, p in enumerate(primes):
        print("Reached (%d,%d)" % (p_idx, p))
        if p * primes[p_idx+1] > LIM:
            break
        for q_idx in xrange(p_idx+1, len(primes)):
            q = primes[q_idx]
            prod = p * q
            if prod > LIM:
                break
            mymax = prod
            prod1 = prod
            while prod1 <= LIM:
                prod2 = prod1
                prev = prod2
                while prod2 <= LIM:
                    prev = prod2
                    prod2 *= p
                if prev > mymax:
                    mymax = prev
                prod1 *= q
            # print("M(%d,%d) = %d" % (p,q,mymax))
            ret += mymax
    print("Result = %d" % ret)


if __name__ == "__main__":
    main()
