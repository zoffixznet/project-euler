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
    return [[get_vec(primes, 1+x) for x in [y, e-y]] for y in xrange(0, e+1)]


def pop_trailing(exps, val):
    ret = 0
    while exps[-1] == val:
        exps.pop()
        ret += 1
    return ret


def calc_C(fact_n):
    primes = [x for x in xrange(2, fact_n+1)
              if len([y for y in xrange(2, 1+int(math.sqrt(x)))
                      if x % y == 0]) == 0]
    print(primes)
    exps = [find_exp(fact_n, p, p) for p in primes]
    print(exps)
    # 1 is {2^1, 2^-1}
    num_1s = pop_trailing(exps, 1)
    # 2 is {3^1, 3^0, 3^-1}
    num_2s = pop_trailing(exps, 2)
    exps_splits = [get_split(primes, e) for e in exps]
    print(exps_splits)
    exps_diffs = [[[x-y for (x, y) in zip(a[0], a[1])] for a in b]
                  for b in exps_splits]
    print(exps_diffs)

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
    print(exps_diffs)

    print("prod=%d ; num_1s=%d ; num_2s=%d" % (prod, num_1s, num_2s))

    return 200


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))


def main():
    print_C(10)
    print_C(100)


if __name__ == "__main__":
    main()
