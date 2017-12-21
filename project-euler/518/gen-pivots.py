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

if sys.version_info > (3,):
    long = int


def main():
    factor_counts = {}
    by_pivots = {}
    l_re = re.compile(r'^[0-9]+: ([0-9 ]+)$')
    with open('./factored.txt') as fh:
        for line in fh:
            line_stripped = line.rstrip('\n')
            m = l_re.match(line_stripped)
            if not m:
                raise BaseException
            factors = m.group(1).split(' ')
            for f in factors:
                if f not in factor_counts:
                    factor_counts[f] = 0
                factor_counts[f] += 1
            pivot = factors[-1]
            if pivot not in by_pivots:
                by_pivots[pivot] = []
            by_pivots[pivot].append(line_stripped)
    for pivot, numbers in by_pivots.iteritems():
        filtered = []
        for line in numbers:
            if all(factor_counts[x] > 2 for x
                   in l_re.match(line).group(1).split(' ')):
                filtered.append(line)
        if len(filtered) > 0:
            with open('./by-pivot-factor/%s.txt' % (pivot), 'w') as o:
                for line in filtered:
                    o.write(line + "\n")
    return


if __name__ == "__main__":
    main()
