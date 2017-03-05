import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def exp_mod(b, e, MOD):
    """docstring for exp_mod"""
    if (e == 0):
        return 1
    if e == 1:
        return b % MOD
    rec = exp_mod(b, e >> 1, MOD)
    return ((rec * rec * exp_mod(b, (e & 1), MOD)) % MOD)


MOD = 10007


def main():
    with open('primes.txt') as in_:
        with open('S1.txt', 'w') as out_:
            k = 1
            for l in in_:
                out_.write('%d\n' % exp_mod(int(l) % MOD, k, MOD))
                k += 1


if __name__ == "__main__":
    main()
