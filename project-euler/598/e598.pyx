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


def get_vec(primes, n):
    return [get_vec_exp(n, p, p, 0) for p in primes]


def get_split(primes, e):
    return [[get_vec(primes, 1+x) for x in [y, e-y]] for y in xrange(e+1)]


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
    cdef int[100] * edd
    cdef int * edde
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
            sys.stdout.flush()

    return ret


def calc_C(int fact_n):
    primes = [x for x in xrange(2, fact_n+1)
              if len([y for y in xrange(2, 1+int(math.sqrt(x)))
                      if x % y == 0]) == 0]
    print(primes)
    sys.stdout.flush()
    exps = [find_exp(fact_n, p, p) for p in primes]
    # 1 is {2^1, 2^-1} which affects position 0.
    num_0s = pop_trailing(exps, 1)
    # 2 is {3^1, 3^0, 3^-1} which affects position 1.
    num_1s = pop_trailing(exps, 2)

    max_0s = 0
    max_1s = 0
    global lookup0
    global lookup1
    lookup0 = [0 for x in xrange(100)]
    lookup1 = [0 for x in xrange(100)]
    for n0p in xrange(num_0s+1):
        n0neg = num_0s-n0p
        num0 = n0p-n0neg
        if num0 > max_0s:
            max_0s = num0
        cnt = nCr(num_0s, n0p)
        if num0 >= 0:
            lookup0[num0] += cnt
    for n1zero in xrange(num_1s+1):
        remain = num_1s-n1zero
        for n1p in xrange(remain+1):
            n1neg = remain-n1p
            num1 = n1p-n1neg
            if num1 > max_1s:
                max_1s = num1
            if num1 >= 0:
                lookup1[num1] += fact(num_1s) / fact(n1zero) \
                / fact(n1p) / fact(n1neg)

    exps_splits = [get_split(primes, e) for e in exps]
    global exps_diffs
    py_exps_diffs = [[[x-y for (x, y) in zip(a[0], a[1])] for a in b]
                  for b in exps_splits]
    global ep_len
    ep_len = len(primes)
    global e_lens
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

    global e_len
    e_len = len(py_exps_diffs)

    for i in xrange(e_len):
        e_lens[i] = len(py_exps_diffs[i])
    while all(all(l[-1] == 0 for l in x) for x in py_exps_diffs):
        ep_len -= 1
        for x in py_exps_diffs:
            for l in x:
                l.pop()

    exps_counts = [len(x) for x in py_exps_diffs]
    prod = long(1)
    for x in exps_counts:
        prod *= x

    # cdef int run_sums[100][100]
    run_sums = []
    sums = [0 for x in xrange(ep_len)]
    run_sums.append([x for x in sums])
    for g_i, l in enumerate(py_exps_diffs):
        print("=== %d" % primes[g_i])
        sys.stdout.flush()
        for d in l:
            print("      %s" % ('  '.join(["%2d" % x for x in d])))
            sys.stdout.flush()
        for i in xrange(len(l[0])):
            sums[i] += max([d[i] for d in l])
        run_sums.append([x for x in sums])
    cdef int s[100]
    for (i,x) in enumerate(run_sums[-1]):
        s[i] = x
    s[0] += max_0s
    s[1] += max_1s
    global rd
    for yi, y in enumerate(run_sums):
        for (si, (ss, x)) in enumerate(zip(s,y)):
            rd[yi][si] = ss-x
    num_runs = [0]
    cdef int rs0[100]
    for i in xrange(ep_len):
        rs0[i] = run_sums[0][i]

    for bi in xrange(ep_len):
        for ai in xrange(e_lens[bi]):
            for xi in xrange(ep_len):
                exps_diffs[bi][ai][xi] = py_exps_diffs[bi][ai][xi]
    ret = recurse(0, rs0)

    print("prod=%d ; num_0s=%d ; num_1s=%d ; ret= %d"
          % (prod, num_0s, num_1s, ret))
    sys.stdout.flush()
    return (ret >> 1)


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))
    sys.stdout.flush()


def main():
    print_C(10)
    print_C(100)


main()
