#!/usr/bin/env python3

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

fibs = [long(1), long(2)]

fib_limit = long("1" + ("0" * 17)) - 1
while fibs[-1] < fib_limit:
    fibs.append(fibs[-1]+fibs[-2])

z_sum = [0, 0, 0]
z_sum[0] = {'up_to': long(1)}
z_sum[1] = {'up_to': long(2)}
z_sum[2] = {'up_to': long(3)}

while len(z_sum) < len(fibs):
    my_len = 1 + len(z_sum)
    z_sum.append({
        'up_to': (z_sum[-1]['up_to'] + z_sum[-2]['up_to'] +
                  fibs[my_len-3] - 1),
        })


def find_sum_up_to_n(n):
    global z_sum
    global fibs

    ret = long(0)
    idx = 0

    while fibs[idx] < n:
        idx += 1

    if (fibs[idx] > n):
        idx -= 1

    ret += z_sum[idx]['up_to']

    remaining = n - fibs[idx]
    if remaining == 0:
        return ret

    ret += find_sum_up_to_n(remaining) + remaining
    return ret


print("Sigma[z](999999) = %d" % find_sum_up_to_n(999999))
print("Solution = %d" % find_sum_up_to_n(fib_limit))
