import sys
from subprocess import check_output
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

# <<<<<<<<<<<<<<<<<<<<
# Originally taken from
# http://rosettacode.org/wiki/Chinese_remainder_theorem#Python -thanks!
#
# Now taken from:
# https://pypi.python.org/pypi/modint/
#


class ChineseRemainderConstructor:
    """Synopsis:

from modint import ChineseRemainderConstructor, chinese_remainder

cr = ChineseRemainderConstructor([2, 5])
assert cr.rem([1, 0]) == 5
assert cr.rem([0, 3]) == 8

# Convenience function
assert chinese_remainder([2, 3, 7], [1, 2, 3]) == 17
    """
    def __init__(self, bases):
        """Accepts a list of integer bases."""
        self._bases = bases
        p = 1
        for x in bases:
            p *= x
        self._prod = p
        self._inverses = [p//x for x in bases]
        self._muls = [inv * self.mul_inv(inv, base) for base, inv
                      in zip(self._bases, self._inverses)]

    def rem(self, mods):
        """Accepts a list of corresponding modulos for the bases and
        returns the accumulated modulo.
        """
        ret = 0
        for mul, mod in zip(self._muls, mods):
            ret += mul * mod
        return ret  # % self._prod

    def mul_inv(self, a, b):
        """Internal method that implements Euclid's modified gcd algorithm.
        """
        initial_b = b
        x0, x1 = 0, 1
        if b == 1:
            return 1
        while a > 1:
            div, mod = divmod(a, b)
            a, b = b, mod
            x0, x1 = x1 - div * x0, x0
        return (x1 if x1 >= 0 else x1 + initial_b)


def chinese_remainder(n, mods):
    """Convenience method that calculates the chinese remainder directly."""
    return ChineseRemainderConstructor(n).rem(mods)
# End of modint
# >>>>>>>>>>>>>>>>>>


def calc_s(n):
    out = check_output(["primesieve", "7", str(n), "-p1"])
    primes = [int(x) for x in out.split("\n") if len(x)]
    ret = (4*3*2*1+3*2*1+2+1+1) % 5
    # print_("p = %d ; ret = %d" % (0, ret))
    for p in primes:
        r = p
        v = 1
        for x in xrange(2, 5):
            v = chinese_remainder([p, p-x], [v, 0]) // (p-x)
            r += v
        ret += r % p
        print_("p = %d ; ret = %d" % (p, ret))
    return ret


def print_s(n):
    print(("S[%d] = %d" % (n, calc_s(n))))
    return


print_s(100)
print_s(100000000)

# Expat License
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
