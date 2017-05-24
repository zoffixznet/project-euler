import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_SIGMA2_mod(MOD, n):
    """docstring for calc_SIGMA2"""
    # MOD = 1000000000
    # MOD = 1000
    sq = 1
    d = 3
    r = 0
    for i in xrange(1, min(MOD, n+1)):
        if sq != 0:
            j = i
            jdiv = n // j
            t = 0
            while jdiv > 1:
                t += jdiv
                j += MOD
                jdiv = n // j
            r = ((r + sq * (t + ((1 + (n - j) // MOD) if j <= n else 0)))
                 % MOD)
        sq = ((sq+d) % MOD)
        d += 2
        print("Reached i=%d ret=%d" % (i, r))
        sys.stdout.flush()
    return r


def main():
    print("Result = %d" % calc_SIGMA2_mod(1000, 1))
    print("Result = %d" % calc_SIGMA2_mod(1000, 2))
    print("Result = %d" % calc_SIGMA2_mod(1000, 3))
    print("Result = %d" % calc_SIGMA2_mod(1000, 4))
    print("Result = %d" % calc_SIGMA2_mod(1000, 5))
    print("Result = %d" % calc_SIGMA2_mod(1000, 6))
    print("Result = %d" % calc_SIGMA2_mod(1000000000, 1000000000000000))


if __name__ == "__main__":
    main()
