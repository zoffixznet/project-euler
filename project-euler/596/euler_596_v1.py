import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_lim2_ret(lim2):
    ret = 0
    max_ = int(math.sqrt(lim2))
    for z in xrange(0, 1+max_):
        # print("z=%d l-z=%d" % (z, lim2 - z*z))
        ret += int(math.sqrt(lim2 - z*z))
    return ret


lim2_cache = {}


def lim2_ret(lim2):
    global lim2_cache
    if lim2 not in lim2_cache:
        lim2_cache[lim2] = calc_lim2_ret(lim2)
        # print("InCache")
    return lim2_cache[lim2]


def calc_T(radius):
    x = 0
    shift = 0
    r_sq = radius*radius
    ret = 0
    lim1 = r_sq
    while lim1 >= 0:
        r = 0
        max_ = int(math.sqrt(lim1))
        for y in xrange(1, 1+max_):
            r += lim2_ret(lim1 - y*y)
        ret += ((((r << 1) + lim2_ret(lim1)) << 2) + (max_ << 1) + 1) << shift
        print("x=%d y=%d" % (x, y))
        sys.stdout.flush()
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
    for lim2 in xrange(0, 10000):
        print("lim2_ret(%d) = %d" % (lim2, calc_lim2_ret(lim2)))
    assert_T(2, 89)
    assert_T(5, 3121)
    assert_T(100, 493490641)
    assert_T(10000, 49348022079085897)
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
