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


def calc_C(fact_n):
    primes = [x for x in xrange(2, fact_n+1)
              if len([y for y in xrange(2, 1+int(math.sqrt(x)))
                      if x % y == 0]) == 0]
    print(primes)
    sys.stdout.flush()
    exps = [find_exp(fact_n, p, p) for p in primes]
    # 1 is {2^1, 2^-1}
    num_1s = pop_trailing(exps, 1)
    # 2 is {3^1, 3^0, 3^-1}
    num_2s = pop_trailing(exps, 2)

    m2 = 0
    m3 = 0
    lookup = {}
    for n1p in xrange(num_1s+1):
        n1neg = num_1s-n1p
        num2 = n1p-n1neg
        if num2 > m2:
            m2 = num2
        cnt = nCr(num_1s, n1p)
        for n2zero in xrange(num_2s+1):
            remain = num_2s-n2zero
            for n2p in xrange(remain+1):
                n2neg = remain-n2p
                num3 = n2p-n2neg
                if num3 > m3:
                    m3 = num3
                key = (num2, num3)
                if key not in lookup:
                    lookup[key] = 0
                lookup[key] += cnt * fact(num_2s) / fact(n2zero) \
                    / fact(n2p) / fact(n2neg)

    exps_splits = [get_split(primes, e) for e in exps]
    exps_diffs = [[[x-y for (x, y) in zip(a[0], a[1])] for a in b]
                  for b in exps_splits]

    g_found = True
    while g_found:
        g_found = False
        new_exp = []
        for g_i, l in enumerate(exps_diffs):
            new_l = []
            for d in l:
                found = False
                for i, x_ in enumerate(d):
                    # We skip 2 and 3 which are indexed 0 and 1
                    if i >= 2:
                        s = 0
                        for ii, ll in enumerate(exps_diffs):
                            if ii != g_i:
                                s += max([dd[i] for dd in ll])
                        if abs(x_) > s:
                            found = True
                            break
                if not found:
                    new_l.append(d)
                else:
                    g_found = True
            new_exp.append(new_l)
        exps_diffs = new_exp

    while all(all(l[-1] == 0 for l in x) for x in exps_diffs):
        for x in exps_diffs:
            for l in x:
                l.pop()

    exps_counts = [len(x) for x in exps_diffs]
    prod = long(1)
    for x in exps_counts:
        prod *= x

    run_sums = []
    sums = [0 for x in exps_diffs[0][0]]
    run_sums.append([x for x in sums])
    for g_i, l in enumerate(exps_diffs):
        print("=== %d" % primes[g_i])
        sys.stdout.flush()
        for d in l:
            print("      %s" % ('  '.join(["%2d" % x for x in d])))
            sys.stdout.flush()
        for i in xrange(len(l[0])):
            sums[i] += max([d[i] for d in l])
        run_sums.append([x for x in sums])
    s = [x for x in run_sums[-1]]
    s[0] += m2
    s[1] += m3
    rd = [[ss-x for (ss, x) in zip(s, y)] for y in run_sums]
    num_runs = [0]

    def recurse(depth, sums):
        if depth == len(exps_diffs):
            key = (sums[0], sums[1])
            return lookup[key] if (key in lookup) else 0
        ret = 0
        d = rd[depth+1]
        for l in exps_diffs[depth]:
            new = [x+y for (x, y) in zip(sums, l)]
            if all(abs(n) <= dd for (n, dd) in zip(new, d)):
                ret += recurse(depth+1, new)
            if depth == 0:
                num_runs[0] += 1
                print("Flutter depth=%d %d / %d" %
                      (depth, num_runs[0], len(exps_diffs[depth])))
                sys.stdout.flush()

        return ret

    ret = recurse(0, run_sums[0])

    print("prod=%d ; num_1s=%d ; num_2s=%d ; ret= %d"
          % (prod, num_1s, num_2s, ret))
    sys.stdout.flush()
    return (ret >> 1)


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))
    sys.stdout.flush()


def main():
    print_C(10)
    print_C(100)


if __name__ == "__main__":
    main()
