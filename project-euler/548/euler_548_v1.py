#!/usr/bin/env python

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


import re
import sys
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int
    xrange = range

cache = {'': long(1)}


def factor_sig(n):
    pipe = Popen(['factor', str(n)], shell=False, stdout=PIPE).stdout
    factors_s = re.sub('^[^:]*:', '', pipe.readline())
    pipe.close()
    sig = {}
    for x in re.findall('[0-9]+', factors_s):
        if x not in sig:
            sig[x] = 0
        sig[x] += 1
    return sorted(sig.values())


def check_factor_sig(n, good):
    if factor_sig(n) != good:
        print("%d is not good" % (n))
        raise BaseException
    return


check_factor_sig(24, [1, 3])
check_factor_sig(100, [2, 2])
check_factor_sig(1000, [3, 3])


# sig must be sorted.
def real_calc_num_chains(sig):
    def helper(so_far, x, all_zeros):
        if x == len(sig):
            return 0 if all_zeros else calc_num_chains(sorted(so_far))
        ret = 0
        n = sig[x]
        for c in xrange(n+1):
            ret += helper(so_far + [n - c] if c < n else so_far,
                          x+1,
                          (all_zeros and (c == 0)))
        return ret
    return helper([], 0, True)


# sig must be sorted.
def calc_num_chains(sig):
    sig_s = ','.join(str(x) for x in sig)
    if sig_s not in cache:
        cache[sig_s] = real_calc_num_chains(sig)
    return cache[sig_s]


def calc_g(n):
    return calc_num_chains(factor_sig(n))


def check_num_chains(n, good):
    if calc_g(n) != good:
        print("calc_num_chains %d is not good" % (n))
        raise BaseException
    return


check_num_chains(12, 8)
check_num_chains(48, 48)
check_num_chains(120, 132)

LIM = long('1' + ('0' * 16))

found = set()
found.add(long(1))


def iter_over_sigs(length):
    if calc_num_chains([1] * length) > LIM:
        return False

    def helper(so_far):
        if len(so_far) == length:
            ret = calc_num_chains(list(reversed(so_far)))
            if ret > LIM:
                return False
            if (ret == calc_g(ret)):
                found.add(ret)
            return True
        for x in xrange(1, so_far[-1]+1):
            if not helper(so_far + [x]):
                if x == 1:
                    return False
        return True
    first = 1
    while True:
        if not helper([first]):
            break
        first += 1
    return True


length = 1
while (iter_over_sigs(length)):
    print("Finished len = %d" % (length))
    length += 1

print("Result = %d" % (sum(found)))
