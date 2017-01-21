import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_G(n):
    series_G = [0, 1]
    last_count = 1
    series_G_sums = [0, 1]
    while series_G_sums[-1] + 1 < n:
        last = series_G[-1]
        if last_count == series_G[last]:
            series_G.append(last+1)
            last_count = 1
        else:
            series_G.append(last)
            last_count += 1
        series_G_sums.append(series_G_sums[-1]+series_G[-1])
    return len(series_G)-(1 if series_G_sums[-1] + 1 > n else 0)


def assert_G(n, exp):
    got = calc_G(n)
    print("G(%d) = %d vs %d" % (n, got, exp))
    if got != exp:
        raise BaseException("fooblead")
    return


def main():
    assert_G(1, 1)
    assert_G(2, 2)
    assert_G(3, 2)
    assert_G(4, 3)
    assert_G(5, 3)
    assert_G(6, 4)
    assert_G(7, 4)
    assert_G(8, 4)
    assert_G(9, 5)
    assert_G(1000, 86)
    assert_G(1000000, 6137)


if __name__ == "__main__":
    main()
