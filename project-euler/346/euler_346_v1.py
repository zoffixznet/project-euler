import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def find_repunits(m):
    h = {1:True}
    LIM = int(math.sqrt(m))
    for b in xrange(2,LIM+1):
        power = b
        s = 1 + power
        power *= b
        s += power
        while s < m:
            # print "found %d" % s
            h[s] = True
            power *= b
            s += power
    ret = long(0)
    for key in h:
        ret += key
    return ret


def print_repunits(m):
    print("repunits-count(%d) = %d" % (m, find_repunits(m)))
    return


def main():
    print_repunits(50)
    print_repunits(1000)
    print_repunits(int('1' + '0' * 12))


if __name__ == "__main__":
    main()
