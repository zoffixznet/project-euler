#!/usr/bin/env python

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

def x(n):
    if n < 2:
        return n
    k = (n >> 1)
    x_k = x(k)
    x_half = x(k >> 1)
    return (((x_k << 1) + 3*(x_half) if (n & 0x1) == 1 else (3*x_k + (x_half << 1))) & ((1 << 60) - 1))

def y(n,k):
    if k >= n:
        return x(k)
    k2 = (k << 1)
    return (((1 << 60) - 1) - max(y(n,k2),y(n,(k2|0x1))))

def A(n):
    return y(n,1)



