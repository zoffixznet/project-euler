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
import os
from six import print_
import numpy as np

if sys.version_info > (3,):
    long = int
    xrange = range


MOD = 1000000007


def brute_S(n_num):
    ret = long(0)
    n = str(n_num)
    for start in xrange(len(n)):
        for end in xrange(start, len(n)):
            ret += long(n[start:end+1])
    return ret % MOD


def smart_S(n_num):
    ret = long(0)
    r = long(0)
    n = str(n_num)
    i = 1
    for d in n:
        ret = (ret*10+int(d)*i) % MOD
        r = (r + ret) % MOD
        i += 1
    return r


def smart2_S(n_num):
    r = long(0)
    n = str(n_num)
    i = len(n)
    e = 1
    for d in n[::-1]:
        r += i*int(d)*e
        r %= MOD
        i -= 1
        e = ((1 + e * 10) % MOD)
    return r


def gen_digit_matrices():
    """
    so the vector is always [r ; i ; e ; i*e ; 1]
    """
    ret = {}
    for d in xrange(0, 10):
        ret[str(d)] = np.matrix(
            [[1, 0, 0, d, 0],
             [0, 1, 0, 0, -1],
             [0, 0, 10, 0, 1],
             # (10e+1)(i-1) = 10ei + i - 10e - 1
             [0, 1, -10, 10, -1],
             [0, 0, 0, 0, 1]], np.int64)
    return ret


digits = gen_digit_matrices()


def matrix_S(n_num):
    m = None
    r = long(0)
    n = str(n_num)
    i = len(n)
    e = 1
    vec = np.array([[r], [i], [e], [i*e], [1]], np.int64)
    for d in n[::-1]:
        if m is None:
            m = digits[d]
        else:
            m = (digits[d] * m) % MOD
    return ((m * vec) % MOD).item(0, 0)


def compare_S(n):
    want = brute_S(n)
    have = matrix_S(n)
    print_("in = %d ; brute = %d ; smart = %d" % (n, want, have))
    if want != have:
        raise BaseException('foo')


def mat_exp_mod(m1, e):
    if e == 1:
        return m1
    sub = mat_exp_mod(m1, (e >> 1))
    ret = ((sub * sub) % MOD)
    if ((e & 1) == 1):
        ret *= m1
    return ret % MOD


def main():
    compare_S(20)
    compare_S(21)
    compare_S(22)
    compare_S(32)
    compare_S(208)
    compare_S(209)
    compare_S(219)
    compare_S(320)
    compare_S(321)
    compare_S(322)
    compare_S(400)
    compare_S(4000)
    compare_S(4001)
    compare_S(4001)
    compare_S(401)
    compare_S(422)
    compare_S(999)
    compare_S(2024)
    compare_S(10000)
    compare_S(10001)
    compare_S(1000000)
    m1 = None
    i = 0
    ns = {}
    for x in xrange(0, 10000):
        ds = []
        x2 = x
        for j in xrange(0, 4):
            ds.append(x2 % 10)
            x2 //= 10
        m = None
        for d in ds:
            if m is None:
                m = digits[str(d)]
            else:
                m = (digits[str(d)] * m) % MOD
        ns[''.join([str(x) for x in ds])] = m
    fn = 'P_1M.txt'
    if not os.path.isfile(fn):
        os.system('python euler_603_v1_step0.py')
    with open(fn, "rb") as f:
        byte = f.read(1)
        m1 = digits[str(byte)]
        byte = f.read(4)
        while len(byte) == 4:
            m1 = (ns[str(byte)] * m1) % MOD
            # Do stuff with byte.
            byte = f.read(4)
            i += 4
            if i % 10000 == 0:
                print_("i=%d" % (i))
        for d in str(byte):
            m1 = (digits[str(d)] * m1) % MOD
    print_(m1)
    k = long('1000000000000')
    n = os.path.getsize(fn)
    m_result = mat_exp_mod(m1, k)
    r = long(0)
    i = ((k * n) % MOD)
    e = 1
    vec = np.array([[r], [i], [e], [i*e], [1]], np.int64)
    print_("Result = %d" % (((m_result * vec) % MOD).item(0, 0)))

    if False:
        for n in xrange(1, 1000000):
            compare_S(n)


if __name__ == "__main__":
    main()
