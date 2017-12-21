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


from divide_fsm import get_div_fsms
import sys

if sys.version_info > (3,):
    xrange = range


def solve_for_d(D):
    # Both 0 and x0 are divisible.
    if (D == 10):
        return 0

    (A, foo) = get_div_fsms(D)
    # A transposed
    T = [[A[x][d] for x in xrange(len(A))] for d in xrange(len(A[0]))]

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

            for d in xrange((0 if ((count == 0) and i > 0) else 1), 10):
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

for d in xrange(1, 20):
    print("Calcing d=%d" % (d))
    sys.stdout.flush()
    sums.append(sums[d-1] + solve_for_d(d))
    print(("F( . 10 ** %d ) = %d. ") % (d, sums[d]))
