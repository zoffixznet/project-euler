import sys

if sys.version_info > (3,):
    long = int
    xrange = range


class Node:
    """docstring for Node"""
    def __init__(self, v, count):
        self.v = v
        self.count = count
        self.next = None
        return


def calc_T(r):
    x = 0
    count = 1
    r_sq = r*r
    ret = 0
    lim1 = r_sq
    while lim1 >= 0:
        y = 0
        c2 = count
        lim2 = lim1
        while lim2 >= 0:
            z = 0
            c3 = c2
            lim3 = lim2
            while lim3 >= 0:
                t = 0
                c4 = c3
                while t*t <= lim3:
                    ret += c4
                    t += 1
                    c4 = c3 << 1
                z += 1
                c3 = c2 << 1
                lim3 = lim2 - z*z
            y += 1
            c2 = count << 1
            lim2 = lim1 - y*y
        x += 1
        count = 2
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
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
