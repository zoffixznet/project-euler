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
import re
from subprocess import check_output

if sys.version_info > (3,):
    long = int
    xrange = range


def count_primes_up_to(n):
    out = check_output(["primesieve", str(n), "-c1"])
    m = re.search(r'(?:Prime numbers|Primes)\s*:\s*([0-9]+)', out)
    return long(m.group(1))


def brute_force_calc_s(n):
    out = check_output(["primesieve", str(n), "-p1"])
    primes = [long(x) for x in out.split("\n") if len(x)]
    h1 = {}
    for x in primes:
        h1[x] = True
    s = len(h1.keys())
    h = h1
    for k in xrange(2, n):
        next_h = {}
        for num in h.keys():
            for p in primes:
                next_num = num + p
                if next_num <= n:
                    next_h[next_num] = True
        s += len(next_h.keys())
        h = next_h
    return s


def calc_s(n):
    if n == 2:
        return len([2])
    if n == 3:
        return len([2, 3])
    if n == 5:
        return len([2, 3, 5, 2+2, 2+3])
    if n == 8:
        return len([2, 3, 5, 7, 2+2, 2+3, 2+5, 3+3, 3+5, 2+2+2, 2+2+3,
                    2+3+3, 2+2+2+2])
    # Calc s[k=1].
    s_1 = count_primes_up_to(n)
    # Calc s[k=2] for i odd.
    s_2 = count_primes_up_to((n if ((n & 0x1) == 1) else n-1)-2)-1
    # Calc the higher s-s for even numbers.
    top_even = (n & (~0x1))
    bottom_even = 4
    even_count_for_k_2 = ((top_even - bottom_even) >> 1) + 1
    even_s = ((even_count_for_k_2 * (1+even_count_for_k_2)) >> 1)

    # Calc the higher s-s for odd numbers.
    top_odd = (n if ((n & 0x1) == 1) else n-1)
    bottom_odd = 2+2+3
    odd_count_for_k_3 = ((top_odd - bottom_odd) >> 1) + 1
    odd_s = ((odd_count_for_k_3 * (1+odd_count_for_k_3)) >> 1)

    return s_1 + s_2 + even_s + odd_s


fibs = [long(0), long(1)]

while len(fibs) < 45:
    fibs.append(fibs[-1] + fibs[-2])

print(fibs)


def print_s(n):
    print(("S[%d] = %d" % (n, calc_s(n))))
    return


print_s(10)
print_s(100)
print_s(1000)


def check_print_s(n):
    calced = calc_s(n)
    real = brute_force_calc_s(n)
    print(("S[%d] = Real = %d ; Calc = %d" % (n, real, calced)))
    if (real != calced):
        raise BaseException
    return


check_print_s(10)
check_print_s(100)
check_print_s(11)
check_print_s(21)
check_print_s(101)
print("Result = %d" % (sum([calc_s(fibs[k]) for k in xrange(3, 45)])))
