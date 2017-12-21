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

if sys.version_info > (3,):
    long = int
    xrange = range

# a b c
# d e f
# g h i


def main(n):
    two_cells_prod = {}
    for b in xrange(-n, n+1):
        print("b=%d" % (b))
        for d in xrange(n+1):
            prod = b*d
            if prod not in two_cells_prod:
                two_cells_prod[prod] = []
            two_cells_prod[prod].append([b, d])
    two_prods_of_two_cells = {}
    MAX = n * n - n
    my_keys = sorted(two_cells_prod.keys())
    my_keys = my_keys[::-1]
    for b_d in my_keys:
        print("b_d=%d" % (b_d))
        # We don't need to consider the negatives due to the duality of
        # the inner loop and because both cannot be negative.
        if b_d < 0:
            break
        for c_g in my_keys:
            s = b_d + c_g
            # a * a - a >= 0 for all a.
            if s < 0:
                break
            if s <= MAX:
                if s not in two_prods_of_two_cells:
                    two_prods_of_two_cells[s] = []
                two_prods_of_two_cells[s].append(
                    [two_cells_prod[b_d], two_cells_prod[c_g]])

    for a in xrange(-n, n+1):
        diff = a*a - a
        if diff in two_prods_of_two_cells:
            for i in two_prods_of_two_cells[diff]:
                for x in i[0]:
                    for y in i[1]:
                        print("%d: %d*%d+%d*%d" % (a, x[0], x[1], y[0], y[1]))


if __name__ == '__main__':
    main(int(sys.argv[1]))
