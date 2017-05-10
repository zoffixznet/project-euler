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
    kn = 2
    ksn = 2*2
    dksn = 3
    while k <= LIM:
        if k == c:
            print("Reached %d" % k)
            sys.stdout.flush()
            c += STEP
        while ksn < s_k:
            kn += 1
            dksn += 2
            ksn += dksn
        sm = s_n = nsq = ksn
        ldm += 2
        dm = dnsq = dksn
        dnsq += 2
        ss_k = s_k
        dk = kdk
        kddk += 2
        ddk = kddk
        kdk += kddk
        for m in xrange(2, k+1):
            while s_n > ss_k:
                sm -= dm
                dm -= 2
                s_n += sm - nsq
                dnsq -= 2
                nsq -= dnsq
            if dm <= ldm:
                break
            if s_n == ss_k:
                print("Found %d" % k)
                sys.stdout.flush()
                break
            ddk -= 2
            dk -= ddk
            ss_k += dk
            nsq += dnsq
            dnsq += 2
            s_n += nsq
        s_k += d
        k += 1
        d += 4


def main():
    find_pivots()


if __name__ == "__main__":
    main()
