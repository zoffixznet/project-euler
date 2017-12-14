#!/usr/bin/env python

import sys
from subprocess import check_output
from six import print_
import heapq

if sys.version_info > (3,):
    long = int
    xrange = range

out = check_output(["primesieve", "3", "1000000", "-p1"])
primes = [int(x) for x in out.split("\n") if len(x)]


class MyIter:
    def __init__(self, coords, ptr, two_exp):
        self.coords = coords
        self.two_exp = two_exp
        self.ptr = ptr

    def next_(self):
        two_exp = self.two_exp
        ret = [MyIter(self.coords, self.ptr, two_exp+1)]
        if two_exp == -len(self.coords):
            p = 0
            while p < self.ptr:
                if p < len(self.coords)-1 and \
                        self.coords[p] == self.coords[p+1]:
                    p += 1
                    continue
                new = [x for x in self.coords]
                for i in xrange(0, p):
                    new[i] = 0
                new[p] += 1
                ret.append(MyIter(new, p+1, two_exp))
                p += 1
        return ret

    def calc(self):
        ret = 1
        for x in self.coords:
            ret *= primes[x]
        return float(ret) * float(2) ** self.two_exp

    def signature(self):
        return {'two': self.two_exp, 'p': [primes[x] for x in self.coords]}


def calc(i):
    return (i.calc(), i)


h = []
n = 1
depth = 0
depthy = None


def inc_depth():
    global depth, depthy
    depth += 1
    depthy = calc(MyIter([0] * depth, depth, -depth))


def push_(item):
    global h
    heapq.heappush(h, item)


inc_depth()
push_(calc(MyIter([], 0, 1)))
# while n < 5:
while n < 1000000:
    if n & (1024-1) == 0:
        print_(n)
    while depthy[0] < h[0][0]:
        push_(depthy)
        inc_depth()
    item = heapq.heappop(h)
    # print_(item[1].signature())
    for x in item[1].next_():
        push_(calc(x))
    n += 1

print_(item)
print_(item[1].signature())
