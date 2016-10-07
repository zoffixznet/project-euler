#!/usr/bin/env python

import os
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

MOD = int(os.environ["MOD"])

groups = {}
zero_count = None
ones_group = None

with open('mod_groups.txt') as f:
    for l in f:
        nums = [long(i) for i in l.rstrip('\n').split(' ')]
        count = nums.pop(0)
        if nums[0] == 0:
            zero_count = count
            nums.pop(0)
            print("Found zero_count is %d" % count)
        if len(nums) and nums[0] == 1:
            ones_group = count
            print("Found ones_group is %d" % count)
        groups[count] = nums

# Total
tot = [long(0) for x in xrange(0, MOD)]
tot[0] = 1
trace_count = 0
for count in ([ones_group] + [x for x in groups.keys() if x != ones_group]):
    nums = groups[count]
    indiv_counts = []
    n = count
    numer = count-1
    denom = 2
    while len(indiv_counts) != count:
        indiv_counts.append(n)
        n = ((n * numer) / denom)
        numer -= 1
        denom += 1
    for n in nums:
        print(("Doing %d [count %d]") % (n, trace_count))
        sys.stdout.flush()
        trace_count += 1
        mods = [long(0) for x in xrange(0, MOD)]
        i = 0
        for d in indiv_counts:
            i += n
            if i >= MOD:
                i -= MOD
            mods[i] += d
        new = [long(0) for x in xrange(0, MOD)]
        new[0] = 1
        for i, v in enumerate(mods):
            if v != 0:
                p = i
                for x in tot:
                    new[p] += v * x
                    p += 1
                    if p == MOD:
                        p = 0
        tot = new

# The -1 is to get rid of the trivial / empty set.
final_result = ((tot[0] << zero_count) - 1)
print("Final result = %d" % final_result)
