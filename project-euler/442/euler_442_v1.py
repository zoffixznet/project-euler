import sys

if sys.version_info > (3,):
    long = int
    xrange = range

C = long(11)
powers = [C]
powers_str = [str(C)]
for i in xrange(0, 40):
    n = powers[-1] * C
    powers.append(n)
    powers_str.append(str(n))


def calc_rev_func_ret(prefix, num_digs):
    if num_digs < 0:
        raise BaseException("digits num is negative")
    ret = 0
    if (len([x for x in powers_str if (x in prefix)]) > 0):
        ret = 0
    elif num_digs == 0:
        ret = 1
        # print "ret =", ret
    else:
        while len(prefix) > 0:
            if len([x for x in powers_str if (x.startswith(prefix))]) > 0:
                break
            prefix = prefix[1:]
        tnumd = len(prefix) + num_digs
        for d in xrange(0, 10):
            np = prefix + str(d)
            # print "np =", prefix, np
            if np not in powers_str:
                filtered = []
                subp = ''
                for c in np[::-1]:
                    subp = str(c) + subp
                    filtered += [x for x in powers_str
                                 if ((len(x) <= tnumd - len(subp) +
                                     len(np)) and x.startswith(subp))]
                if len(filtered) == 0:
                    if num_digs == 1:
                        ret += 1
                    else:
                        ret += rev_func_ret('', num_digs-1)
                else:
                    ret += rev_func_ret(np, num_digs-1)
                # print "qpo =", np, num_digs, ret, filtered
    # print "ret =", ret
    return ret
    # b 26 , num_digs == 0


rev_func_cache = {('', 0): 1, ('', 1): 10}
for d in xrange(1, 10):
    rev_func_cache[(str(d), 0)] = 1


def rev_func_ret(prefix, num_digs):
    global rev_func_cache
    nnp = prefix
    while len(nnp) > 0 and nnp[0] == '0':
        nnp = nnp[1:]
    key = (nnp, num_digs)
    if key not in rev_func_cache:
        if len(nnp) <= 4:
            rev_func_cache[key] = calc_rev_func_ret(nnp, num_digs)
        else:
            return calc_rev_func_ret(nnp, num_digs)
        # print("InCache")
    return rev_func_cache[key]


def n_rev_func(n):
    s = str(n)
    ret = 0
    my_len = len(s)
    ns = ''
    for i, c in enumerate(s):
        lns = ns + str(c)
        for d in xrange((0 if i > my_len-1 or my_len > 0 else 1), 10):
            nns = ns + str(d)
            if nns == lns:
                break
            # print "nns=", nns
            d = rev_func_ret(nns, my_len-len(nns))
            # print "d=", d
            ret += d
        ns = lns
    ret += rev_func_ret(s, 0)
    return ret - 1


def r(n):
    ret = n_rev_func(n)
    print("E(%d) ~~ %d" % (ret, n))
    P = 1000000000000000000
    if ret < P:
        print("  => Too low")
    elif ret > P:
        print("  => Too high")
    else:
        print("  => Perfectish")
    return ret


def assert_T(r, want):
    got = n_rev_func(r)
    print("T(%d) = %d vs %d" % (r, got, want))
    if got != want:
        raise BaseException("fooblead")


def check_T(n):
    want = 0
    for i in xrange(1, n+1):
        got = n_rev_func(i)
        s = str(i)
        if not [x for x in powers_str if (x in s)]:
            want += 1
        print("checkT(%d) = %d vs %d" % (i, got, want))
        if got != want:
            raise BaseException("wrong result")
    return


def main():
    assert_T(120, 109)
    assert_T(3, 3)
    assert_T(9, 9)
    assert_T(11, 10)
    assert_T(20, 19)
    assert_T(21, 20)
    assert_T(99, 98)
    assert_T(100, 99)
    assert_T(213, 200)
    assert_T(531563, 500000)
    # check_T(531563)
    r(1000000000000)
    r(1000000000000000000)
    r(2000000000000000000)
    r(1500000000000000000)
    r(1250000000000000000)
    r(1350000000000000000)
    r(1300000000000000000)
    r(1270000000000000000)
    r(1290000000000000000)
    r(1297000000000000000)
    r(1295000000000000000)
    r(1296000000000000000)
    r(1295500000000000000)
    r(1295750000000000000)
    r(1295620000000000000)
    r(1295580000000000000)
    r(1295570000000000000)
    r(1295560000000000000)
    r(1295550000000000000)
    r(1295555000000000000)
    r(1295552500000000000)
    r(1295553500000000000)
    r(1295553000000000000)
    r(1295552700000000000)
    r(1295552600000000000)
    r(1295552650000000000)
    r(1295552680000000000)
    r(1295552665000000000)
    r(1295552660000000000)
    r(1295552662000000000)
    r(1295552661000000000)
    r(1295552661600000000)
    r(1295552661300000000)
    r(1295552661450000000)
    r(1295552661550000000)
    r(1295552661500000000)
    r(1295552661525000000)
    r(1295552661537000000)
    r(1295552661530000000)
    r(1295552661534000000)
    r(1295552661532000000)
    r(1295552661531000000)
    r(1295552661530050000)
    r(1295552661530550000)
    r(1295552661530950000)
    r(1295552661530750000)
    r(1295552661530850000)
    r(1295552661530900000)
    r(1295552661530930000)
    r(1295552661530920000)
    r(1295552661530920900)
    r(1295552661530920200)
    r(1295552661530920150)
    r(1295552661530920148)
    r(1295552661530920149)


if __name__ == "__main__":
    main()
