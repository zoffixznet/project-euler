#!/usr/bin/python

import re
import sys
from subprocess import check_output
from collections import defaultdict


def divisors(s):
    s = re.sub(r'\A([0-9]+):\s*', '', s)
    f = defaultdict(int)
    for i in re.findall(r'\S+', s):
        f[int(i)] += 1
    return f


def t_div(n):
    return divisors(check_output(['factor', str(n)]).decode('utf-8'))


def num_ways_2sq(n):
    f = t_div(n)
    res = 1
    for i, e in f.items():
        m = (i & 3)
        if m == 3:
            if e % 2:
                return 0
        elif m == 1:
            res *= e+1
    return (res+1) >> 1


print(num_ways_2sq(int(sys.argv[1])))
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
