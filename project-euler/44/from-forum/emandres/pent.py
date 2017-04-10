from math import sqrt
import sys

if sys.version_info > (3,):
    xrange = range


def pent(x):
    return x*(3*x-1)/2


def is_pent(x):
    f = (.5 + sqrt(.25+6*x))/3
    if f - int(f) == 0:
        return True
    else:
        return False


flag = False
for i in xrange(1, 3000):
    if i % 100 == 0:
        print('i = %d' % (i))
    for j in xrange(i+1, 3000):
        if is_pent(pent(j) - pent(i)) and is_pent(pent(j) + pent(i)):
            print('answer = %d' % (pent(j) - pent(i)))
            flag = True
            break
    if flag:
        break
