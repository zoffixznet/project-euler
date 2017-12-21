#!/usr/bin/env python3

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


class ArithSeq:
    def __init__(self):
        self.i = 1

    # The next element.
    def n(self):
        ret = self.i
        self.i += 1
        return ret

    def sum(self, cnt):
        bottom = self.i
        self.i += cnt
        top = self.i - 1
        return (((long(top) + long(bottom)) * long(cnt)) >> 1)


class FracSeq:
    def __init__(self):
        self._a = ArithSeq()
        self._q = [['a', 1, 0], ['f', 1, 1]]
        self._f = False

    def _append(self):
        if (not self._f):
            self._f = FracSeq()
            self._f.n()
        new_peek = self._f.n()
        self._q.append(['a', long(math.sqrt(new_peek)), 0])
        self._q.append(['f', 1, new_peek])
        return

    def n(self):
        first = self._q[0]
        (which, count, peek) = first[0], first[1], first[2]
        if (count == 0):
            if (which == 'f'):
                self._append()
            self._q.pop(0)
            return self.n()
        first[1] -= 1
        if (which == 'a'):
            return self._a.n()
        else:
            return peek

    def sum(self, cnt):
        ret = long(0)
        # Trace
        t = 1000000000
        fc = 0
        while (cnt > 0):
            while (fc > t):
                print("Reached %d" % t)
                t += 1000000000
            first = self._q[0]
            (which, count, peek) = first[0], first[1], first[2]
            c = 0
            if (which == 'a'):
                c = (count if (count < cnt) else cnt)
                ret += self._a.sum(c)
            else:
                c = 1
                ret += peek
                self._append()
            cnt -= c
            fc += c
            if c == count:
                self._q.pop(0)
            else:
                first[1] -= c
        return ret


def frac_sum(n):
    return FracSeq().sum(n)


def debug_sum(n):
    print("T(%d) = %d\n" % (n, frac_sum(n)))


debug_sum(20)
debug_sum(1000)
debug_sum(1000000000)
debug_sum(long('1000000000000000000'))
