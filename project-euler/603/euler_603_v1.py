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


def main():
    print_(brute_S(2024))


if __name__ == "__main__":
    main()
