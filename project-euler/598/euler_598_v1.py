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

def calc_C(fact_n):
    primes = [x for x in xrange(2, fact_n+1) if len([y for y in xrange(2,1+int(math.sqrt(x))) if x%y == 0]) == 0]
    print(primes)
    exps = [find_exp(fact_n, p, p) for p in primes]
    print(exps)

    return 200


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))


def main():
    print_C(10)
    print_C(100)


if __name__ == "__main__":
    main()
