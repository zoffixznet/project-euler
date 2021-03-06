#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2018, Shlomi Fish
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


from six import print_
from six.moves import range
# import struct
import numpy as np

BASE = 1000000000 + 7

C = {}


def lookup_pp(n, k):
    s = n + k
    return C[s][(n - k) >> 1]


def dump_pp(n, kk, v):
    if v == 0:
        return
    s = n + kk
    if s not in C:
        C[s] = np.zeros((s >> 1)+2, dtype=np.int32)
    # print_(s, n, k, len(C[s].keys()))
    # C[s].append(v)
    # C[s] += struct.pack('I', v)
    t = (1 + kk)
    if ((t & 3) != 2):
        C[s][t] = v


def calc_Ps(max_):
    ret = [0, 1]
    # dump_pp(0, 0, 0)
    # dump_pp(1, 0, 0)
    dump_pp(1, 1, 1)
    # dump_pp(2, 1, 0)
    start = 2
    m = 2
    for n in range(2, max_+1):
        if n == m:
            start += 1
            m += start
        print_('n =', n)
        pp = 0
        # dump_pp(n, 0, pp)
        # dump_pp(n, 1, pp)
        # s = n - k <= k - 1
        # 2k >= n+1
        # k >= (n+1)/2
        lim = (n+2) >> 1
        key = n - 1
        if key in C:
            q = C[key]
            del C[key]
        else:
            q = np.zeros(lim, dtype=np.int32)
        for k in range(start, lim):
            pp = ((pp + q[k]) % BASE)
            # print_(n, k, pp)
            dump_pp(n, k, pp)
        t = n - lim
        for k in range(lim, n):
            pp = ((pp + (0 if ((k & 3) == 2) else ret[t])) % BASE)
            dump_pp(n, k, pp)
            t -= 1
        if ((n & 3) == 2):
            delta = 0
        else:
            delta = 1
        pp = ((pp + delta) % BASE)
        dump_pp(n, n, pp)
        ret.append(pp)
    return ret


def main():
    ret = calc_Ps(1000)
    assert ret[1] == 1
    assert ret[2] == 0
    assert ret[3] == 1
    assert ret[6] == 1
    assert ret[10] == 3
    assert ret[100] == 37076
    assert ret[1000] == (3699177285485660336 % BASE)
    ret = calc_Ps(10000000)
    r = sum(ret)
    print_("ret = %d ; %d" % (r, r % BASE))


main()
