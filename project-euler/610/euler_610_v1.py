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


import sys
from bigfloat import BigFloat, precision
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

with precision(1000):
    def roman_digit(d, one, five, ten):
        if d % 5 == 4:
            return one + roman_digit(d+1, one, five, ten)
        if d == 0:
            return ''
        if d == 5:
            return five
        if d == 10:
            return ten
        return roman_digit((d//5)*5, one, five, ten) + one * (d % 5)

    def roman_num(n):
        ret = ''
        ret = roman_digit(n % 10, 'I', 'V', 'X') + ret
        n //= 10
        ret = roman_digit(n % 10, 'X', 'L', 'C') + ret
        n //= 10
        ret = roman_digit(n % 10, 'C', 'D', 'M') + ret
        return ret

    tree = {'val': 0, 'next': {}}

    for n in xrange(1, 1000):
        node = tree
        s = roman_num(n)
        print(s)
        for l in s:
            nxt = node['next']
            if l not in nxt:
                nxt[l] = {'val': 0, 'next': {}}
            node = nxt[l]
        node['val'] = n

    R = BigFloat('0.14')

    def calc_node(node, r):
        tot = 2
        for sub in 'IVXLCDM':
            if sub in node['next']:
                tot += 14
        mult = BigFloat('100')/tot
        ret_thousands = r * BigFloat('0.02') * mult
        ret_v = node['val'] * ret_thousands
        sub_r = r * R * mult
        for sub in node['next'].values():
            sub_v, sub_t = calc_node(sub, sub_r)
            ret_v += sub_v
            ret_thousands += sub_t
        return ret_v, ret_thousands

    r_v, r_thousands = calc_node(tree, BigFloat('1') - R)
    thousands = 0
    val = BigFloat('0')
    while True:
        val += r_v + r_thousands * thousands
        print_(thousands, val)
        r_v *= R
        r_thousands *= R
        thousands += 1000
