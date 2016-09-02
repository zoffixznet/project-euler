#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

MOD = 250


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
        if nums[0] == 1:
            ones_group = count
            print("Found ones_group is %d" % count)
        groups[count] = nums
