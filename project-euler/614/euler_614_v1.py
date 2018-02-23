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


def dump_pp(n, vals):
    s = k = n
    for v in vals:
        if s not in C:
            C[s] = np.zeros((s >> 1)+1, dtype=np.int32)
        # print_(s, n, k, len(C[s].keys()))
        # C[s].append(v)
        # C[s] += struct.pack('I', v)
        C[s][k >> 1] = v
        # C[s][k] = v
        s += 1
        k -= 1


def calc_Ps(max_):
    ret = [0, 1]
    dump_pp(0, [0])
    dump_pp(1, [0, 1])
    for n in range(2, max_+1):
        print_('n =', n)
        pp = [0]
        # s = n - k <= k - 1
        # 2k >= n+1
        # k >= (n+1)/2
        lim = (n+2) >> 1
        q = C[n - 1]
        del C[n - 1]
        t = ((n+1) >> 1) - 1
        for k in range(1, lim):
            pp.append((pp[-1] +
                       (0 if ((k & 3) == 2)
                           else q[t])) % BASE)
            t -= 1
        for k in range(lim, n):
            pp.append((pp[-1] + (0 if ((k & 3) == 2) else ret[n-k])) % BASE)
        if ((n & 3) == 2):
            delta = 0
        else:
            delta = 1
        pp.append((pp[-1] + delta) % BASE)
        dump_pp(n, pp)
        ret.append(pp[-1])
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
