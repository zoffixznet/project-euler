import sys

if sys.version_info > (3,):
    long = int
    xrange = range

LIM = 10000000000


def find_pivots():
    initial_k = 2
    s_k = 1*1+2*2
    kdk = 1
    kddk = 1
    d = 8
    STEP = 10000000
    c = STEP
    ldm = (((initial_k-1) << 1) - 1)
    ksn = 2*2
    dksn = 3
    for k in xrange(initial_k, LIM+1):
        if k == c:
            print("Reached %d" % k)
            sys.stdout.flush()
            c += STEP
        while ksn < s_k:
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
                print(">>> S[ %d .. %d ; %d] = S[ %d .. %d ; %d]" %
                      (k-m+1, k, m, ((dm + 1) >> 1), ((dnsq - 1) >> 1), m-1))
                sys.stdout.flush()
                break
            ddk -= 2
            dk -= ddk
            ss_k += dk
            nsq += dnsq
            dnsq += 2
            s_n += nsq
        s_k += d
        d += 4


def main():
    find_pivots()


if __name__ == "__main__":
    main()
