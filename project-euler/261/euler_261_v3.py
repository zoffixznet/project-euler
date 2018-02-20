# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
            while s_n > ss_k and dm > ldm:
                sm -= dm
                dm -= 2
                s_n += sm - nsq
                dnsq -= 2
                nsq -= dnsq
            if s_n == ss_k:
                print("Found %d" % k)
                print(">>> S[ %d .. %d ; %d] = S[ %d .. %d ; %d] ( %d )" %
                      (k-m+1, k, m, ((dm + 1) >> 1), ((dnsq - 1) >> 1), m-1,
                       ((dm + 1) >> 1) - k))
                sys.stdout.flush()
            if dm <= ldm:
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
