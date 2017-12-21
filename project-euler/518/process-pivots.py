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
import os
import sys

if sys.version_info > (3,):
    long = int


def main():
    nums = {}
    with open('primes.txt') as fh:
        for line in fh:
            nums[1+int(line)] = True

    re_f = re.compile('^([0-9]+)\.txt$')
    total_sum = long(0)
    for fn in os.listdir('by-pivot-factor'):
        t = re_f.match(fn)
        if t:
            pivot = int(t.group(1))
            print("Handling %d" % (pivot))
            local_n = []
            with open('by-pivot-factor/' + fn) as fh:
                for x in fh:
                    local_n.append(int(x.split(':')[0]))
            for r in local_n:
                sq = r * r
                lookup = {}
                for x in local_n:
                    lookup[x] = False
                for i in local_n:
                    if i != r:
                        j, m = divmod(sq, i)
                        if m == 0:
                            if j in nums:
                                is_local = (j in lookup)
                                if not (is_local and lookup[j]):
                                    if is_local:
                                        lookup[j] = True
                                    print("Found %d,%d,%d" % (i, r, j))
                                    total_sum += ((i+r+j)-3)
    print("Total sum = %d" % total_sum)
    return


if __name__ == "__main__":
    main()
