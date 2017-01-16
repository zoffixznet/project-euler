#!/usr/bin/env python

from divide_fsm import get_div_fsms
import sys


def solve_for_d(D):
    # Both 0 and x0 are divisible.
    if (D == 10):
        return 0

    (A, foo) = get_div_fsms(D)
    # A transposed
    T = [[A[x][d] for x in range(0, len(A))] for d in range(0, len(A[0]))]

    # my @S = ((0) x $D);
    # D *M*inus 1.
    cache = {}

    def rec(i, S, count):
        key = str(count) + ',' + ','.join(str(x) for x in sorted(S))

        if key in cache:
            return cache[key]
#         if (0)
#         {
#             if ($D == 8)
#             {
#                 print "Sorted = $key\n";
#             }
#         }

        if (i == D):
            cache[key] = count
            return count
        else:
            ret = 0

            for d in range((0 if ((count == 0) and i > 0) else 1), 10):
                r = T[d]
                N = [r[k] for k in S + [0]]

                # $nc == new_count
                nc = count + len([x for x in N if x == 0])
                if nc < 2:
                    ret += rec(i+1, N, nc)
            cache[key] = ret
            return ret

    return rec(0, [], 0)


sums = []

sums.append(0)

for d in range(1, 20):
    print("Calcing d=%d" % (d))
    sys.stdout.flush()
    sums.append(sums[d-1] + solve_for_d(d))
    print(("F( . 10 ** %d ) = %d. ") % (d, sums[d]))
