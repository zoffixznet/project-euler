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


def fact_F(n, d):
    M = int('1' + '0' * len(str(d)))
    RM = 10000000000000000 + 61
    old = [0 for i in xrange(M)]
    old[1] = 1
    for ii in xrange(2, n+1):
        i = ii % M
        new = [x+0 for x in old]
        newmod = i
        print('i = ', i)
        for j in xrange(1, M):
            new[newmod] += old[j]
            while new[newmod] >= RM:
                new[newmod] -= RM
            newmod += i
            if newmod >= M:
                newmod -= M
        old = new
        print('old = ', [(x, y) for x, y in enumerate(old)])
        if True:
            verify_old = [0 for i in xrange(M)]

            def rec(j, prod):
                if j > ii:
                    verify_old[prod % M] += 1
                else:
                    rec(j+1, prod)
                    rec(j+1, prod*j)
            rec(2, 1)
            verify_old[0] = old[0]
            print('ver_old = ', [(x, y) for x, y in enumerate(verify_old)])
            if verify_old != old:
                raise BaseException("Foo")
        # print('newmod = ', newmod)
    print(M)
    return old[d]


def main():
    print(fact_F(12, 12))
    # print(fact_F(50, 123))


if __name__ == "__main__":
    main()
