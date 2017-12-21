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

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_digits_sum(n):
    return sum(int(x) for x in str(n))


A0 = long(1)

idx = long(1)
a_n = A0
d_s = calc_digits_sum(a_n)

calced_arr = []


def ins(n, digits_sum, idx):
    global calced_arr
    calced_arr.append({'n': n, 's': digits_sum, 'i': idx})
    return


ins(a_n, d_s, idx)

NUM_DIGITS = 30

cache = [[{} for number_of_invariant_digits in xrange(NUM_DIGITS+1)]
         for digits_sum in xrange(NUM_DIGITS*9+1)]


def calc_next():
    global a_n, idx, d_s
    a_n += d_s
    d_s = calc_digits_sum(a_n)
    idx += 1


def _format_n(n):
    return (("%0" + str(NUM_DIGITS) + "d") % n)


def _format(s):
    return _format_n(s['n'])


def _common_len(s, e):
    for i in xrange(NUM_DIGITS):
        if s[i] != e[i]:
            return i-1
    raise Exception


def cache_delta():
    global calced_arr
    # Start and end.
    my_i = len(calced_arr)-2
    s = calced_arr[my_i]
    e = calced_arr[my_i+1]
    s_digits = _format(s)
    e_digits = _format(e)
    for i in xrange(1, _common_len(s_digits, e_digits)+1):
        cache[s['s']][i][s_digits[i:]] = my_i


calc_next()
ins(a_n, d_s, idx)
cache_delta()

# LIM = long(1000000)
LIM = long(1000000000000000)


def _print_me():
    global a_n, idx, d_s
    print(("a[%d] = %d") % (idx, a_n))


while idx < LIM:
    _print_me()
    a_s = _format_n(a_n)
    to_proc = True
    for i in xrange(1, NUM_DIGITS):
        sub_s = a_s[i:]
        lookup = cache[d_s][i]
        if sub_s in lookup:
            start_arr_i = lookup[sub_s]
            prefix = _format(calced_arr[start_arr_i])[:i]
            base_idx = idx - calced_arr[start_arr_i]['i']
            end_arr_i = start_arr_i + 1
            new_idx = base_idx + calced_arr[end_arr_i]['i']
            while (end_arr_i < len(calced_arr) and
                   _format(calced_arr[end_arr_i])[:i] == prefix and
                   new_idx <= LIM):
                end_arr_i += 1
                new_idx = base_idx + calced_arr[end_arr_i]['i']
            end_arr_i -= 1
            new_idx = base_idx + calced_arr[end_arr_i]['i']
            if end_arr_i > start_arr_i:
                a_n += calced_arr[end_arr_i]['n'] \
                       - calced_arr[start_arr_i]['n']
                idx = new_idx
                d_s = calced_arr[end_arr_i]['s']
                to_proc = False
                break

    if to_proc:
        calc_next()

    ins(a_n, d_s, idx)
    cache_delta()

_print_me()
