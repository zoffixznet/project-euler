import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def exp15(b, MOD):
    r = ((b * b * b * b * b) % MOD)
    return ((r * r * r) % MOD)


def main():
    LIM = 100000000000
    with open('primes.txt') as in_:
        for l in in_:
            p = int(l)
            q = p - 1
            m = LIM % p
            c1 = 0
            for i in xrange(1, m+1):
                if exp15(i, p) == q:
                    # print("Found %d for %d" % (i, p))
                    c1 += 1
            c = c1
            for i in xrange(m+1, p):
                if exp15(i, p) == q:
                    # print("Found %d for %d" % (i, p))
                    c += 1
            print("R = %d for %d" % ((((LIM // p) * c + c1) * p), p))


if __name__ == "__main__":
    main()
