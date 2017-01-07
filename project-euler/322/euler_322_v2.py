import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

def mydiv(i,e):
    ret = (i/e)*e;
    if ret < i:
        return ret + e
    else:
        return ret

def calc_base_iter(b, n):
    """docstring for calc_base_iter"""
    power = 1
    digits = []
    base_sum = 0
    while n != 0:
        n, d = divmod(n, b)
        if d == b-1:
            base_sum += d*power
        else:
            digits.append([i*power for i in xrange(d, b)])
        power *= b
    return {'base_sum': base_sum, 'b': b, 'digits': digits[::-1], 'power': power}

def base_iter(it):
    base_sum = it['base_sum']
    b = it['b']
    d = it['digits']
    p = it['power']
    def f(s, i):
        if i == len(d):
            yield s
        else:
            for x in d[i]:
                for y in f(s+x,i+1):
                    yield y
    s = base_sum
    while True:
        for x in f(s, 0):
            yield x
        s += p

class IterWrap:
    """docstring for IterWrap"""
    def __init__(self, b, n):
        self.b, self.n = b, n
        self.it = base_iter(calc_base_iter(b, n))
        self.c = 0
        self.next()
        return;

    def next(self):
        """docstring for next"""
        self.i = self.it.next()
        self.c += 1
        return

def T(m, n):
    i = [IterWrap(2, n), IterWrap(5, n)]
    c = 0
    while i[0].i < m and i[1].i < m:
        print i[0].i
        if i[0].i == i[1].i:
            c += 1
            i[0].next()
        while i[0].i < i[1].i:
            i[0].next()
        while i[0].i > i[1].i:
            i[1].next()
    while i[0].i < m:
        i[0].next()
    while i[1].i < m:
        i[1].next()

    return (m - n - (i[0].c - 1 + i[1].c - 1 - c))

def print_T(m, n):
    print("T( m = %d, n = %d) = %d" % (m,n, T(m,n)))
    return

def main():
    # print_T(100,5)
    m = long('1' + '0' * 9)
    n = long(10000000 - 10)
    print_T(m, n)

if __name__ == "__main__":
    main()
