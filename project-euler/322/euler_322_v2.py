import sys
import functools

if sys.version_info > (3,):
    long = int
    xrange = range


# <<<<<<<<<<<<<<<<<<<<
# Taken from http://rosettacode.org/wiki/Chinese_remainder_theorem#Python -
# thanks!
# Python 2.7
def chinese_remainder(prod, n, p_n, a):
    sum = 0
    for n_i, p, a_i in zip(n, p_n, a):
        sum += a_i * mul_inv(p, n_i) * p
    return sum % prod


def mul_inv(a, b):
    b0 = b
    x0, x1 = 0, 1
    if b == 1:
        return 1
    while a > 1:
        q = a / b
        a, b = b, a % b
        x0, x1 = x1 - q * x0, x0
    if x1 < 0:
        x1 += b0
    return x1

# End of Rosetta code.
# >>>>>>>>>>>>>>>>>>


def mydiv(i, e):
    ret = (i/e)*e
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
    return {'base_sum': base_sum, 'b': b, 'digits': digits[::-1],
            'power': power}


def base_iter(it):
    base_sum = it['base_sum']
    d = it['digits']
    p = it['power']

    def f(s, i):
        if i == len(d):
            yield s
        else:
            for x in d[i]:
                for y in f(s+x, i+1):
                    yield y
    s = base_sum
    while True:
        for x in f(s, 0):
            yield x
        s += p


class IterWrap:
    """docstring for IterWrap"""
    def __init__(self, b, n, d):
        self.b, self.n = b, n
        self.d = d
        self.it = base_iter(self.d)
        self.c = 0
        self.next()
        return

    def next(self):
        """docstring for next"""
        self.i = self.it.next()
        self.c += 1
        return

    def skip_to(self, m):
        """docstring for skip_to"""
        p = self.d['power']
        count_per_p = functools.reduce(
            (lambda a, b: a*b), (len(x) for x in self.d['digits']))
        num = long((m - self.i) / p)
        delta = num * p
        self.i += delta
        self.c += count_per_p * num
        while self.i < m:
            self.i = delta + self.it.next()
            self.c += 1
        return


def calc_common(m, n):
    i2 = IterWrap(2, n, calc_base_iter(2, n))
    ret = 0
    p2 = i2.d['power']
    d = calc_base_iter(5, n)
    i5 = IterWrap(5, n, d)
    p5 = d['power']
    p = p2 * p5
    a = (p, [p2, p5], [p5, p2])
    m_i_s = [mul_inv(p_i, n_i) * p_i for n_i, p_i in zip(a[1], a[2])]
    m2 = m_i_s[0]
    m5 = m_i_s[1]
    while i2.i < p2:
        print(i2.i, "/", p2)
        j2 = i2.i * m2
        i5 = IterWrap(5, n, d)
        while i5.i < p5:
            mod_ = ((j2 + i5.i * m5) % p)
            while mod_ < m:
                ret += 1
                mod_ += p
            i5.next()
        i2.next()
    return ret


def T(m, n):
    i = [IterWrap(2, n, calc_base_iter(2, n)),
         IterWrap(5, n, calc_base_iter(5, n))]
    i[0].skip_to(m)
    i[1].skip_to(m)
    c_calc = calc_common(m, n)
    print("c_calc = %d" % (c_calc))
    return (m - n - (i[0].c - 1 + i[1].c - 1 - c_calc))


def print_T(m, n):
    print("T( m = %d, n = %d) = %d" % (m, n, T(m, n)))
    return


def main():
    # print_T(100,5)
    m = long('1' + '0' * 9)
    n = long(10000000 - 10)
    # print_T(m, n)
    m = long('1' + '0' * 18)
    n = long('1' + '0' * 12) - 10
    print_T(m, n)

if __name__ == "__main__":
    main()
