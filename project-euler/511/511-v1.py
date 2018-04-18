#!/usr/bin/python

import re
from subprocess import check_output
from collections import defaultdict


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


def t_div(n):
    return divisors(check_output(['factor', str(n)]).decode('utf-8'))


def calc_Seq(n, k):
    one = [0 for x in range(k)]
    for d in t_div(n):
        one[d % k] += 1

    def mult(xx, yy):
        ret = [0 for x in range(k)]
        for i, x in enumerate(xx):
            ii = i
            for y in yy:
                ret[ii] += x*y
                ii += 1
                if ii == k:
                    ii = 0
        return [x % 1000000000 for x in ret]

    def myexp(e):
        print('start', e)
        if e == 1:
            return one
        if e & 1:
            return mult(myexp(e-1), one)
        rec = myexp(e >> 1)
        print('end', e)
        return mult(rec, rec)
    ret = myexp(n)
    return ret[k - n % k]


assert calc_Seq(3, 4) == 4
assert calc_Seq(4, 11) == 8
assert calc_Seq(1111, 24) == 840643584
print('answer = %09d' % (calc_Seq(1234567898765, 4321)))

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
