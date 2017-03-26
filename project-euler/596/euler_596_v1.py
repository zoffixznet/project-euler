import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_lim2_ret(lim2):
    ret = 0
    max_ = int(math.sqrt(lim2))
    for z in xrange(1, 1+max_):
        ret += int(math.sqrt(lim2 - z*z))
    return (((ret + max_) << 2) | 1)


lim2_cache = {}


def lim2_ret(lim2):
    global lim2_cache
    if lim2 not in lim2_cache:
        lim2_cache[lim2] = calc_lim2_ret(lim2)
    else:
        pass
        # print("InCache")
    return lim2_cache[lim2]


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
            ret += (lim2_ret(lim2) << s2)
            y += 1
            s2 = d2
            lim2 = lim1 - y*y
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
    assert_T(2, 89)
    assert_T(5, 3121)
    assert_T(100, 493490641)
    assert_T(10000, 49348022079085897)
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
