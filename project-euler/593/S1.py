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


def exp_mod(b, e, MOD):
    """docstring for exp_mod"""
    if (e == 0):
        return 1
    if e == 1:
        return b % MOD
    rec = exp_mod(b, e >> 1, MOD)
    return ((rec * rec * exp_mod(b, (e & 1), MOD)) % MOD)


MOD = 10007


def main():
    with open('primes.txt') as in_:
        with open('S1.txt', 'w') as out_:
            k = 1
            for l in in_:
                out_.write('%d\n' % exp_mod(int(l) % MOD, k, MOD))
                k += 1


if __name__ == "__main__":
    main()
