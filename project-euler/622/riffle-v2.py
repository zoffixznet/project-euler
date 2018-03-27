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


def pow_div(n):
    return t_div((1 << n) - 1)


n = 60

divs = pow_div(n)
for h in range(1, n):
    if n % h == 0:
        divs.difference_update(pow_div(h))

s = sum([x+1 for x in divs])
print("sum = %d" % (s))

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
