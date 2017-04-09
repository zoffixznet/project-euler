import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_C(fact_n):
    primes = [x for x in xrange(2, fact_n+1) if len([y for y in xrange(2,1+int(math.sqrt(x))) if x%y == 0]) == 0]
    print(primes)

    return 200


def print_C(n):
    print("C(%d!) = %d" % (n, calc_C(n)))


def main():
    print_C(10)


if __name__ == "__main__":
    main()
