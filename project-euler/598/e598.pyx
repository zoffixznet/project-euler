import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def find_exp(n, p, m):
    if m > n:
        return 0
    else:
        return (int(n / m) + find_exp(n, p, m*p))


def get_vec_exp(n, p, m, e):
    if n % m == 0:
        return get_vec_exp(n, p, m*p, e+1)
    else:
        return e


def get_vec(p_len, primes, n):
    return [get_vec_exp(n, p, p, 0) for p in primes[0:p_len]]


def get_split(p_len, primes, e):
    return [[get_vec(p_len, primes, 1+x) for x in [y, e-y]] for y in xrange(0, e+1)]


def pop_trailing(exps, val):
    ret = 0
    while exps[-1] == val:
        exps.pop()
        ret += 1
    return ret


def fact(n):
    ret = long(1)
    for i in xrange(2, n+1):
        ret *= i
    return ret


def nCr(n, k):
    return fact(n) / fact(k) / fact(n-k)


cdef int e_len, ep_len
cdef int exps_diffs[100][100][100]
cdef long long lookup0[100]
cdef long long lookup1[100]
cdef int rd[100][100]
cdef int e_lens[100]

cdef long long recurse(int depth, int sums[100]):
    if depth == e_len:
        return lookup0[abs(sums[0])] * lookup1[abs(sums[1])]
    cdef long long ret
    ret = 0
    cdef int * d
    d = rd[depth+1]
    cdef int new[100]
    cdef int num_runs
    cdef int edd[100][100]
    cdef int edde[100]
    edd = exps_diffs[depth]
    num_runs = 0
    cdef int ei, i
    for ei in range(e_lens[depth]):
        edde = edd[ei]
        ok = True
        for i in range(ep_len):
            new[i] = sums[i] + edde[i]
            if abs(new[i]) > d[i]:
                ok = False
                break
        if ok:
            ret += recurse(depth+1, new)
        if depth == 0:
            num_runs += 1
            print("Flutter depth=%d %d / %d" %
                  (depth, num_runs, e_lens[depth]))

    return ret


def calc_C(int fact_n):
    cdef int primes[100]
    cdef int p_len
    p_len = 0
    for x in xrange(2, fact_n+1):
        if len([y for y in xrange(2, 1+int(math.sqrt(x))) if x % y == 0]) == 0:
            primes[p_len] = x
            p_len += 1
    print(primes)
    exps = [find_exp(fact_n, p, p) for p in primes[0:p_len]]
    print(exps)
    # 1 is {2^1, 2^-1}
    num_1s = pop_trailing(exps, 1)
    # 2 is {3^1, 3^0, 3^-1}
    num_2s = pop_trailing(exps, 2)
    # p_len -= num_1s + num_2s

    m2 = 0
    m3 = 0
    global lookup0
    global lookup1
    lookup0 = [0 for x in xrange(100)]
    lookup1 = [0 for x in xrange(100)]
    for n1p in xrange(0, num_1s+1):
        n1neg = num_1s-n1p
        num2 = n1p-n1neg
        if num2 > m2:
            m2 = num2
        cnt = nCr(num_1s, n1p)
        if num2 >= 0:
            lookup0[num2] += cnt
    for n2zero in xrange(0, num_2s+1):
        remain = num_2s-n2zero
        for n2p in xrange(0, remain+1):
            n2neg = remain-n2p
            num3 = n2p-n2neg
            if num3 > m3:
                m3 = num3
            if num3 >= 0:
                lookup1[num3] += fact(num_2s) / fact(n2zero) \
                / fact(n2p) / fact(n2neg)

    print("lookup1 = ", lookup1)

    exps_splits = [get_split(p_len, primes, e) for e in exps]
    print(exps_splits)
    global exps_diffs
    py_exps_diffs = [[[x-y for (x, y) in zip(a[0], a[1])] for a in b]
                  for b in exps_splits]
    global e_len
    e_len = len(exps_splits)
    global ep_len
    ep_len = p_len
    global e_lens
    for bi in xrange(0, len(exps_splits)):
        e_lens[bi] = len(exps_splits[bi])
        for ai in xrange(0, e_lens[bi]):
            for xi in xrange(0, ep_len):
                t1 = exps_splits[bi][ai]
                # exps_diffs[bi][ai][xi] = t1[0][xi] - t1[1][xi]
    # print(exps_diffs)

    g_found = True
    while g_found:
        g_found = False
        new_exp = []
        for g_i, l in enumerate(py_exps_diffs):
            new_l = []
            for d in l:
                found = False
                for i, x_ in enumerate(d):
                    # We skip 2 and 3 which are indexed 0 and 1
                    if i >= 2:
                        mysum = 0
                        for ii, ll in enumerate(py_exps_diffs):
                            if ii != g_i:
                                mysum += max([dd[i] for dd in ll])
                        if abs(x_) > mysum:
                            found = True
                            break
                if not found:
                    new_l.append(d)
                else:
                    g_found = True
            new_exp.append(new_l)
        py_exps_diffs = new_exp
        e_len = len(new_exp)
        for i in xrange(0, e_len):
            e_lens[i] = len(new_exp[i])

    while all(all(l[ep_len-1] == 0 for l in py_exps_diffs[ei][0:e_lens[ei]]) for ei in xrange(0, e_len)):
        ep_len -= 1
        for x in py_exps_diffs:
            for y in x:
                y.pop()

    exps_counts = [len(x) for x in py_exps_diffs]
    prod = long(1)
    for x in exps_counts:
        prod *= x
    # print(exps_diffs)
    print("Appl");

    # cdef int run_sums[100][100]
    run_sums = []
    sums = [0 for x in xrange(0,ep_len)]
    run_sums.append([x for x in sums])
    for g_i, l in enumerate(py_exps_diffs):
        print('g_i', g_i)
        print("=== %d" % primes[g_i])
        for d in l:
            print("      %s" % ('  '.join(["%2d" % x for x in d])))
        for i in xrange(0, len(l[0])):
            print('i<bread>=', i, 'ep_len=', ep_len, )
            sums[i] += max([d[i] for d in l])
        run_sums.append([x for x in sums])
    cdef int s[100]
    for (i,x) in enumerate(run_sums[-1]):
        s[i] = x
    s[0] += m2
    s[1] += m3
    global rd
    for yi, y in enumerate(run_sums):
        for (si, (ss, x)) in enumerate(zip(s,y)):
            rd[yi][si] = ss-x
    num_runs = [0]
    cdef int rs0[100]
    for i in xrange(0, ep_len):
        rs0[i] = run_sums[0][i]

    for bi in xrange(0, ep_len):
        for ai in xrange(0, e_lens[bi]):
            for xi in xrange(0, ep_len):
                exps_diffs[bi][ai][xi] = py_exps_diffs[bi][ai][xi]
    ret = recurse(0, rs0)

    print("prod=%d ; num_1s=%d ; num_2s=%d ; ret= %d"
          % (prod, num_1s, num_2s, ret))
    return (ret >> 1)


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))


def main():
    print_C(10)
    print_C(100)


main()
