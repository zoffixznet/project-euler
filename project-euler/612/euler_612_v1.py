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
    if not w_zero:
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
    else:
        raise BaseException("unimplemented")


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
