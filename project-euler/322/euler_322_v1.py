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


def mydiv(i, e):
    ret = (i/e)*e
    if ret < i:
        return ret + e
    else:
        return ret


class Powers:
    """docstring for Powers"""
    def __init__(self, p, max_, i):
        self.p = p
        self.i = i
        self.max_ = max_

        e = p
        self.a = [[e, mydiv(i, e)]]
        while e < max_:
            e *= p
            self.a.append([e, mydiv(i, e)])
        return

    def calc(self):
        i = self.i
        r = 0
        for x in self.a:
            if x[1] == i:
                r += 1
                x[1] += x[0]
            else:
                break
        self.i += 1
        return r


def C(i, n):
    return (math.factorial(i) / (math.factorial(n) * math.factorial(i-n)))


def _base(n, b):
    if n == 0:
        return ''
    return _base(long(n/b), b) + str(n % b)


def get_i5_cond(n, i):
    if n == '':
        return True
    return int(n[0]) <= int(i[0]) and get_i5_cond(n[1:], i[1:])


def T(m, n):
    def gen_power(b, i):
        return Powers(long(b), m, i)

    def gen_2_5(i):
        return [gen_power(2, i), gen_power(5, i)]
    numer = gen_2_5(n+1)
    denom = gen_2_5(1)
    s = [0, 0]
    ret = 0
    n5b = _base(n, 5)
    for i in xrange(n, m):
        t_cond = (s[0] < 1)
        if False:
            i_cond = (((i | 1) & (n | 1)) == (n | 1))
            if i_cond:
                print(("[I] 0b%s" % _base(i, 2)), s[0], s[1])
            if t_cond:
                print(("[T] 0b%s" % _base(i, 2)), s[0], s[1])
            if i_cond != t_cond:
                raise BaseException("%d" % i)
        t5_cond = (s[1] < 1)
        if False:
            i5b = _base(i, 5)
            if t5_cond:
                print("[5T] 0[5]%50s\n     0[5]%50s\n" % (i5b, n5b))
            i5_cond = get_i5_cond(n5b[::-1], i5b[::-1])
            if i5_cond:
                print("[5I] 0[5]%50s\n     0[5]%50s\n" % (i5b, n5b))
            if i5_cond != t5_cond:
                raise BaseException("0[5] %d" % i)
        if t_cond and t5_cond:
            i5b = _base(i, 5)
            print(("[tG] %d %d" % (i, n)), s[0], s[1])
            print(("[2G] 0b%s" % _base(i, 2)), s[0], s[1])
            print("[5G] 0[5]%50s\n     0[5]%50s\n" % (i5b, n5b))
        if s[0] >= 1 and s[1] >= 1:
            ret += 1
        for j in [0, 1]:
            s[j] += numer[j].calc() - denom[j].calc()
        if i % 1000000 == 0:
            print("i = %d ; ret = %d" % (i, ret))
            sys.stdout.flush()
    return ret


def print_T(m, n):
    print("T( m = %d, n = %d) = %d" % (m, n, T(m, n)))
    return


def main():
    # print_T(100,5)
    m = long('1' + '0' * 9)
    n = long(10000000 - 10)
    print_T(m, n)


if __name__ == "__main__":
    main()
