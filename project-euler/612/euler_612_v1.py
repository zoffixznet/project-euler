#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

FACTS = [long(1)]
for n in xrange(1, 100):
    FACTS.append(FACTS[-1] * n)

print_(FACTS[10])


def calc_count(l, w_zero, num_nat_digits):
    n_zero = 1 if w_zero else 0
    num_digits = num_nat_digits + n_zero
    if num_digits > l:
        return 0
    if w_zero:
        ret = 0
        # Choose a pivot for the first place and go for it
        for cnt in xrange(l-1):
            ret += FACTS[l-1]/FACTS[cnt]/FACTS[l-1-cnt] * \
                   calc_count(l-1-cnt, False, num_nat_digits)
        return ret * num_nat_digits

    def rec(counts, s):
        if s > l:
            return 0
        if len(counts) == num_digits:
            if s != l:
                return 0
            ret = FACTS[l] * FACTS[num_digits]
            repeats = {}
            for x in counts:
                ret /= FACTS[x]
                if x not in repeats:
                    repeats[x] = 0
                repeats[x] += 1
            for v in repeats.values():
                ret /= FACTS[v]
            return ret
        ret = 0
        for nxt in xrange(1, (counts[-1]+1 if len(counts)
                              else l-num_digits+1+1)):
            ret += rec(counts + [nxt], s + nxt)
        return ret
    return rec([], 0)


def calc_count_brute(l, w_zero, num_nat_digits):
    good = set(xrange((0 if w_zero else 1), num_nat_digits+1))
    ret = 0
    for n in xrange(10**(l-1), 10**(l)):
        found = good.copy()
        i = n
        ok = True
        while i > 0:
            d = i % 10
            if d not in good:
                ok = False
                break
            found.discard(d)
            i //= 10
        if ok and len(found) == 0:
            ret += 1
    return ret


def comp(l, num_nat_digits):
    want = calc_count_brute(l, False, num_nat_digits)
    have = calc_count(l, False, num_nat_digits)
    print_("For l = %d and n = %d : %d vs %d" %
           (l, num_nat_digits, want, have))
    if have != want:
        raise BaseException("mismatch")


def comp0(l, num_nat_digits):
    want = calc_count_brute(l, True, num_nat_digits)
    have = calc_count(l, True, num_nat_digits)
    print_("For[0] l = %d and n = %d : %d vs %d" %
           (l, num_nat_digits, want, have))
    if have != want:
        raise BaseException("mismatch")


comp(1, 1)
comp(2, 1)
comp(3, 1)
comp(4, 1)
comp(2, 2)
comp(3, 2)
comp(3, 3)
comp(4, 2)
comp(4, 3)
comp(4, 4)
if False:
    for l in xrange(1, 9):
        for n in xrange(1, l+1):
            comp(l, n)

comp0(2, 0)
comp0(2, 1)
comp0(2, 2)
comp0(3, 0)
comp0(3, 1)
comp0(3, 2)
comp0(3, 3)
comp0(4, 0)
comp0(4, 1)
comp0(4, 2)
comp0(4, 3)
comp0(4, 4)
if False:
    for l in xrange(1, 9):
        for n in xrange(l+1):
            # comp0(l, n)
            comp(l, n)


def bitmask(n):
    if n == 0:
        return 0
    else:
        return ((1 << (n % 10)) | bitmask(n // 10))


def solve_brute(l):
    MAX = 10 ** l
    ret = long(0)
    s = [bitmask(q) for q in xrange(MAX)]
    for p in xrange(1, MAX):
        print_("p = ", p)
        m = s[p]
        for q in xrange(p+1, MAX):
            if ((m & s[q]) != 0):
                ret += 1
    return ret


print_("s = %d" % (solve_brute(2)))


def solve(myl):
    counts = []
    for z in [False, True]:
        for n in xrange(9+1):
            v = sum([calc_count(l, z, n) for l in xrange(myl+1)])
            if v > 0:
                counts.append((z, n, v))
    print_(counts)
    ret = long(0)
    for i in xrange(len(counts)):
        zi, ni, vi = counts[i]
        for j in xrange(i, len(counts)):
            zj, nj, vj = counts[j]
            for num_common in xrange(1+min(ni, nj)):
                if num_common == 0 and (not zi or not zj):
                    continue
                i_num_diff = ni - num_common
                j_num_diff = nj - num_common
                digs = num_common + i_num_diff + j_num_diff
                if digs > 9:
                    continue
                i_ret = (vi*vj) * FACTS[9] / \
                    FACTS[num_common] / FACTS[i_num_diff] / \
                    FACTS[j_num_diff] / FACTS[9 - digs]
                r = i_ret
                if i == j:
                    if num_common == ni:
                        r -= vi * FACTS[9] / FACTS[ni] \
                            / FACTS[9 - ni]
                else:
                    r *= 2

                print_("num_common=", num_common, "i=", i, "j=", j,
                       "i_ret=", i_ret, "r=", r)
                ret += r
    return ret >> 1


print_("s[fast] = %d" % (solve(2)))


def comps(l):
    want = solve_brute(l)
    have = solve(l)
    print_("For[s] l = %d : %d vs %d" % (l, want, have))
    if have != want:
        raise BaseException("solve mismatch")


comps(2)
comps(1)
comps(3)
comps(4)
# comps(5)

my_solution = solve(18)
print_("solution = %d ( MOD = %d )" % (my_solution, my_solution % 1000267129))
