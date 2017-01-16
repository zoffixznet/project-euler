#!/usr/bin/env python3
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
    l = 1 + len(z_sum)
    z_sum.append({
        'up_to': (z_sum[-1]['up_to'] + z_sum[-2]['up_to'] + fibs[l-3] - 1),
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
