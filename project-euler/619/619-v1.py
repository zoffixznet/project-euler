#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import re

"""

"""

bases = {}
nxt = 0
nums = []
zeros_count = 0
with open('db3.txt', 'r') as f:
    for line in f:
        s = re.sub('.*: ?', '', line.strip())
        print(s)
        n = {}
        for b in s.split(' '):
            if b == '':
                continue
            b = int(b)
            if b not in bases:
                bases[b] = nxt
                nxt += 1
            n[b] = True
        if len(n.keys()) > 0:
            nums.append(n)
        else:
            zeros_count += 1
print(nums)
if False:
    # mat = np.zeros((len(nums), nxt), dtype='bool')
    for i, n in enumerate(nums):
        for b in n:
            pass  # mat[i][bases[b]] = True

mod = True
iterat = 0
num_nums = len(nums)
while mod:
    mod = False
    iterat += 1
    print('it=', iterat, num_nums)
    for b in sorted(list(bases.keys())):
        print('b=', b, iterat, num_nums)
        min1 = -1
        min_size = 10000000
        i = 0
        while i < num_nums:
            n = nums[i]
            if b in n:
                if len(n.keys()) < min_size:
                    min1 = i
                    min_size = len(n.keys())
            i += 1
        if min1 >= 0:
            if min_size == 1:
                del bases[b]

            i = 0
            while i < num_nums:
                if i != min1:
                    repl = True
                    while repl:
                        repl = False
                        n = nums[i]
                        if b in n:
                            new_n = {k: True for k in n.keys()}
                            for k in nums[min1].keys():
                                if k in n:
                                    del new_n[k]
                                else:
                                    new_n[k] = True
                            if len(new_n.keys()):
                                nums[i] = new_n
                            else:
                                num_nums -= 1
                                nums[i] = nums[num_nums]
                                nums[num_nums] = {}
                                if num_nums == min1:
                                    min1 = i
                                else:
                                    repl = True
                            mod = True
                i += 1


def expmod(b, e, M):
    if e == 0:
        return 1
    rec = expmod(b, e >> 1, M)
    return (((b if ((e & 1) == 1) else 1) * rec * rec) % M)


# rank = matrix_rank(mat)
rank = len([n for n in nums if len(n.keys()) > 0])
lr = len(nums)-rank + zeros_count
lre = expmod(2, lr, 1000000007) - 1
print(rank, lr, lre)
