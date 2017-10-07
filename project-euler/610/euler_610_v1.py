#!/usr/bin/env python

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
        ret_thousands = BigFloat('0.02') * mult
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
