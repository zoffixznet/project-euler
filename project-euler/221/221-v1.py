#!/usr/bin/python

import re
from subprocess import check_output
from collections import defaultdict
import sys
import heapq


if sys.version_info > (3,):
    long = int
    xrange = range


def divisors(s):
    s = re.sub(r'\A([0-9]+):\s*', '', s)
    f = defaultdict(int)
    for i in re.findall(r'\S+', s):
        f[int(i)] += 1
    return fact(list(f.items()))


def fact(L):
    if len(L) == 0:
        return set([1])
    else:
        f, m = L[0]
        r = fact(L[1:])

        x = 1
        ret = set()
        for e in range(0, m+1):
            ret = ret.union(set([x * y for y in r]))
            x *= f
        return ret


with open('f.txt', 'w') as o:
    for p in xrange(1, 150000):
        o.write("%d\n" % (p*p+1))

lines = check_output(['bash', '-c', 'factor < f.txt']).decode(
                     'utf-8').split("\n")


def t_div(n):
    global lines
    return divisors(lines.pop(0))


h = []
heapq.heapify(h)
m = {}
for p in xrange(1, 150000+1):
    print('p=', p)
    pp = p*p+1
    divs = t_div(pp)
    for d in divs:
        n = -p*(p+d)*(p+pp//d)
        if n not in m:
            heapq.heappush(h, n)
            m[n] = True
            while len(h) > 150000:
                del m[heapq.heappop(h)]
print(h)
print('%d' % (- min(h)))

'''

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut

'''
