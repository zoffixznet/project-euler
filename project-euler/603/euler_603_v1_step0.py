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
import math
from six import print_

if sys.version_info > (3,):
    xrange = range


def main():
    ret = ['2', ]
    fn = 'P_1M.txt'
    cnt = 1
    n = 3
    GOAL = 1000000
    while cnt < GOAL:
        is_prime = True
        for x in xrange(3, int(math.sqrt(n))+1, 2):
            if (n % x == 0):
                is_prime = False
                break
        if is_prime:
            cnt += 1
            ret.append(str(n))
            if cnt % 1000 == 0:
                print_('Reached %d out of %d' % (cnt, GOAL))
        n += 2
    print_('Writing')
    with open(fn, 'wb') as fh:
        for c in ret[::-1]:
            fh.write(c[::-1])
    print_('Finished writing')


if __name__ == "__main__":
    main()
