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

def ass_y(n,k,expected):
    got = y(n,k)
    if (got != expected):
        print( "y(%d,%d) = %d != %d" % (n,k,got,expected))
        raise BaseException
    return

def ass_A(n,expected):
    got = A(n)
    if (got != expected):
        print( "A(%d) = %d != %d" % (n,got,expected))
        raise BaseException
    return

ass_y(4,4,11)
ass_y(4,3,((1 << 60)-9))
ass_y(4,2,((1 << 60)-12))
ass_y(4,1,8)
ass_A(10, ((1 << 60)-34))
ass_A(1000, 101881)
