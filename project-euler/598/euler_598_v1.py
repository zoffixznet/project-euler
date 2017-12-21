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


def find_exp(n, p, m):
    if m > n:
        return 0
    else:
        return (int(n / m) + find_exp(n, p, m*p))


def get_vec_exp(n, p, m, e):
    if n % m == 0:
        return get_vec_exp(n, p, m*p, e+1)
    else:
        return e


def get_vec(primes, n):
    return [get_vec_exp(n, p, p, 0) for p in primes]


def get_split(primes, e):
    return [[get_vec(primes, 1+x) for x in [y, e-y]] for y in xrange(e+1)]


def pop_trailing(exps, val):
    ret = 0
    while exps[-1] == val:
        exps.pop()
        ret += 1
    return ret


def fact(n):
    ret = long(1)
    for i in xrange(2, n+1):
        ret *= i
    return ret


def nCr(n, k):
    return fact(n) / fact(k) / fact(n-k)


def calc_C(fact_n):
    primes = [x for x in xrange(2, fact_n+1)
              if len([y for y in xrange(2, 1+int(math.sqrt(x)))
                      if x % y == 0]) == 0]
    print(primes)
    sys.stdout.flush()
    exps = [find_exp(fact_n, p, p) for p in primes]
    # 1 is {2^1, 2^-1} which affects position 0.
    num_0s = pop_trailing(exps, 1)
    # 2 is {3^1, 3^0, 3^-1} which affects position 1.
    num_1s = pop_trailing(exps, 2)

    max_0s = 0
    max_1s = 0
    lookup0 = [0 for x in primes + [0]]
    lookup1 = [0 for x in primes + [0]]
    for n0p in xrange(num_0s+1):
        n0neg = num_0s-n0p
        num0 = n0p-n0neg
        if num0 > max_0s:
            max_0s = num0
        cnt = nCr(num_0s, n0p)
        if num0 >= 0:
            lookup0[num0] += cnt
    for n1zero in xrange(num_1s+1):
        remain = num_1s-n1zero
        for n1p in xrange(remain+1):
            n1neg = remain-n1p
            num1 = n1p-n1neg
            if num1 > max_1s:
                max_1s = num1
            if num1 >= 0:
                lookup1[num1] += fact(num_1s) / fact(n1zero) \
                    / fact(n1p) / fact(n1neg)

    exps_splits = [get_split(primes, e) for e in exps]
    exps_diffs = [[[x-y for (x, y) in zip(a[0], a[1])] for a in b]
                  for b in exps_splits]

    g_found = True
    while g_found:
        g_found = False
        new_exp = []
        for g_i, l in enumerate(exps_diffs):
            new_l = []
            for d in l:
                found = False
                for i, x_ in enumerate(d):
                    # We skip 2 and 3 which are indexed 0 and 1
                    if i >= 2:
                        s = 0
                        for ii, ll in enumerate(exps_diffs):
                            if ii != g_i:
                                s += max([dd[i] for dd in ll])
                        if abs(x_) > s:
                            found = True
                            break
                if not found:
                    new_l.append(d)
                else:
                    g_found = True
            new_exp.append(new_l)
        exps_diffs = new_exp

    while all(all(l[-1] == 0 for l in x) for x in exps_diffs):
        for x in exps_diffs:
            for l in x:
                l.pop()

    exps_counts = [len(x) for x in exps_diffs]
    prod = long(1)
    for x in exps_counts:
        prod *= x

    run_sums = []
    sums = [0 for x in exps_diffs[0][0]]
    run_sums.append([x for x in sums])
    for g_i, l in enumerate(exps_diffs):
        print("=== %d" % primes[g_i])
        sys.stdout.flush()
        for d in l:
            print("      %s" % ('  '.join(["%2d" % x for x in d])))
            sys.stdout.flush()
        for i in xrange(len(l[0])):
            sums[i] += max([d[i] for d in l])
        run_sums.append([x for x in sums])
    s = [x for x in run_sums[-1]]
    s[0] += max_0s
    s[1] += max_1s
    rd = [[ss-x for (ss, x) in zip(s, y)] for y in run_sums]
    num_runs = [0]

    def recurse(depth, sums):
        if depth == len(exps_diffs):
            return lookup0[abs(sums[0])] * lookup1[abs(sums[1])]
        ret = 0
        d = rd[depth+1]
        for l in exps_diffs[depth]:
            new = [x+y for (x, y) in zip(sums, l)]
            if all(abs(n) <= dd for (n, dd) in zip(new, d)):
                ret += recurse(depth+1, new)
            if depth == 0:
                num_runs[0] += 1
                print("Flutter depth=%d %d / %d" %
                      (depth, num_runs[0], len(exps_diffs[depth])))
                sys.stdout.flush()

        return ret

    ret = recurse(0, run_sums[0])

    print("prod=%d ; num_0s=%d ; num_1s=%d ; ret= %d"
          % (prod, num_0s, num_1s, ret))
    sys.stdout.flush()
    return (ret >> 1)


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))
    sys.stdout.flush()


def main():
    print_C(10)
    print_C(100)


if __name__ == "__main__":
    main()
