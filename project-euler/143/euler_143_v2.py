import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def main():
    for a in xrange(1, 120000):
        print("a = %d" % (a))
        as_ = a*a
        for b in xrange(1, a+1):
            bs = b*b
            bb = bs - as_
            b4 = -(bb * bb)
            ab = ((as_+bs) << 1)
            for c in xrange(1, b+1):
                cs = c*c
                Z = b4+(cs*(ab-cs))
                if Z < 0:
                    continue
                Z3 = 3 * Z
                zroot = long(math.sqrt(Z3))
                if zroot*zroot != Z3:
                    continue
                an_sq = as_+bs+cs+zroot
                if an_sq & 1:
                    continue
                an_sq >>= 1
                an = long(math.sqrt(an_sq))
                if an > 120000:
                    break
                if an*an != an_sq:
                    continue
                print(an)
                if an == 0:
                    print('0 for a=%d b=%d c=%d' % (a, b, c))


if __name__ == "__main__":
    main()
