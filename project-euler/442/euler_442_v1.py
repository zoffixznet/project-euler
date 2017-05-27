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
                                 if ((len(x) <= tnumd - len(subp) + len(np))
                                     and x.startswith(subp))]
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
        rev_func_cache[key] = calc_rev_func_ret(nnp, num_digs)
        # print("InCache")
    return rev_func_cache[key]


def n_rev_func(n):
    s = str(n)
    ret = 0
    l = len(s)
    ns = ''
    for i, c in enumerate(s):
        lns = ns + str(c)
        for d in xrange((0 if i > l-1 or l > 0 else 1), 10):
            nns = ns + str(d)
            if nns == lns:
                break
            # print "nns=", nns
            d = rev_func_ret(nns, l-len(nns))
            # print "d=", d
            ret += d
        ns = lns
    ret += rev_func_ret(s, 0)
    return ret - 1


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
    check_T(531563)


if __name__ == "__main__":
    main()
