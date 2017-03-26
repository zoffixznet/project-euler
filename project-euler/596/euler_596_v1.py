import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_T(r):
    x = 0
    shift = 0
    r_sq = r*r
    ret = 0
    lim1 = r_sq
    while lim1 >= 0:
        y = 0
        s2 = shift
        d2 = s2 + 1
        lim2 = lim1
        while lim2 >= 0:
            z = 0
            s3 = s2
            d3 = s3 + 1
            lim3 = lim2
            while lim3 >= 0:
                ret += (((int(math.sqrt(lim3)) << 1) | 1) << s3)
                z += 1
                s3 = d3
                lim3 = lim2 - z*z
            y += 1
            s2 = d2
            lim2 = lim1 - y*y
        x += 1
        shift = 1
        lim1 = r_sq-x*x
    return ret


def assert_T(r, want):
    got = calc_T(r)
    print("T(%d) = %d vs %d" % (r, got, want))
    if got != want:
        raise BaseException("fooblead")
    return


def main():
    assert_T(2, 89)
    assert_T(5, 3121)
    assert_T(100, 493490641)
    # assert_T(10000, 49348022079085897)
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
