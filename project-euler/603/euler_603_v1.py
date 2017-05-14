import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


MOD = 1000000007


def brute_S(n_num):
    ret = long(0)
    n = str(n_num)
    for start in xrange(len(n)):
        for end in xrange(start, len(n)):
            ret += long(n[start:end+1])
    return ret % MOD


def smart_S(n_num):
    ret = long(0)
    r = long(0)
    n = str(n_num)
    i = 1
    for d in n:
        ret = (ret*10+int(d)*i) % MOD
        r = (r + ret) % MOD
        i += 1
    return r


def smart2_S(n_num):
    r = long(0)
    n = str(n_num)
    i = len(n)
    e = 1
    for d in n[::-1]:
        r += i*int(d)*e
        r %= MOD
        i -= 1
        e = ((1 + e * 10) % MOD)
    return r


def compare_S(n):
    want = brute_S(n)
    have = smart2_S(n)
    print_("in = %d ; brute = %d ; smart = %d" % (n, want, have))
    if want != have:
        raise BaseException('foo')


def main():
    compare_S(20)
    compare_S(21)
    compare_S(22)
    compare_S(32)
    compare_S(208)
    compare_S(209)
    compare_S(219)
    compare_S(320)
    compare_S(321)
    compare_S(322)
    compare_S(400)
    compare_S(4000)
    compare_S(4001)
    compare_S(4001)
    compare_S(401)
    compare_S(422)
    compare_S(999)
    compare_S(2024)
    compare_S(10000)
    compare_S(10001)
    compare_S(1000000)
    if False:
        for n in xrange(1, 1000000):
            compare_S(n)


if __name__ == "__main__":
    main()
