import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

LIM = 10000000000


def find_pivots():
    k = 2
    s_k = 1*1+2*2
    k_m = 1
    STEP = 10000000
    c = STEP
    while k <= LIM:
        if k == c:
            print("Reached %d" % k)
            sys.stdout.flush()
            c += STEP
        n = long(math.sqrt(s_k))
        s_n = n*n
        n_m = n
        ss_k = s_k
        k_mm = k_m
        for m in xrange(2,k+1):
            while s_n > ss_k:
                n_m -= 1
                s_n += n_m*n_m-n*n
                n -= 1
            if n_m <= k:
                break
            if s_n == ss_k:
                print("Found %d" % k)
                sys.stdout.flush()
                break
            k_mm -= 1
            ss_k += k_mm*k_mm
            n += 1
            s_n += n*n
        k += 1
        s_k += k*k-k_m*k_m
        k_m += 1


def main():
    find_pivots()
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
