import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range

LIM = 10000000000


def find_pivots():
    k = 2
    s_k = 1*1+2*2
    kdk = 1
    kddk = 1
    d = 8
    STEP = 10000000
    c = STEP
    ldm = (((k-1) << 1) - 1)
    while k <= LIM:
        if k == c:
            print("Reached %d" % k)
            sys.stdout.flush()
            c += STEP
        n = long(math.sqrt(s_k))
        sm = s_n = n*n
        ldm += 2
        dm = ((n << 1) - 1)
        ss_k = s_k
        dk = kdk
        kddk += 2
        ddk = kddk
        kdk += kddk
        for m in xrange(2, k+1):
            while s_n > ss_k:
                sm -= dm
                dm -= 2
                s_n += sm-n*n
                n -= 1
            if dm <= ldm:
                break
            if s_n == ss_k:
                print("Found %d" % k)
                sys.stdout.flush()
                break
            ddk -= 2
            dk -= ddk
            ss_k += dk
            n += 1
            s_n += n*n
        s_k += d
        k += 1
        d += 4


def main():
    find_pivots()
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
