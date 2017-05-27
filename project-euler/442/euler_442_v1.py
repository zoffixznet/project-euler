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
        raise BaseException("gloop")
    ret = 0
    tnumd = len(prefix) + num_digs
    for d in xrange(0, 10):
        np = prefix + str(d)
        if np not in powers_str:
            filtered = [x for x in powers_str
                        if ((len(x) <= tnumd) and x.startswith(np))]
            if len(filtered) == 0:
                ret += rev_func_ret('', num_digs-1)
            else:
                ret += rev_func_ret(np, num_digs-1)
    return ret
    # b 26 , num_digs == 0


rev_func_cache = {('', 0): 0, ('', 1): 9}
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
    s = str(n+1)
    ret = 0
    l = len(s)
    ns = ''
    for i, c in enumerate(s):
        lns = ns + str(c)
        for d in xrange(0, 10):
            nns = ns + str(d)
            if nns == lns:
                break
            ret += rev_func_ret(nns, l-len(nns))
        ns = lns
    return ret


def assert_T(r, want):
    got = n_rev_func(r)
    print("T(%d) = %d vs %d" % (r, got, want))
    if got != want:
        raise BaseException("fooblead")
    return


def main():
    assert_T(3, 3)


if __name__ == "__main__":
    main()
