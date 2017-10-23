import math
import sys

if sys.version_info > (3,):
    long = int
    xrange = range


def is_prime(n):
    if n == 1 or ((n & 1) == 0 and n != 2):
        return False
    for d in xrange(3, int(math.sqrt(n))+2, 2):
        if n % d == 0:
            return False
    return True


def rec(MAX_D, d, n, s):
    if is_prime(n // s):
        for x in [1, 3, 7, 9]:
            print(n * 10 + x)
    if d == MAX_D:
        return
    for x in xrange(10):
        new_s = s+x
        new_n = n*10+x
        if new_n % new_s == 0:
            rec(MAX_D, d+1, new_n, new_s)


def main():
    for x in xrange(1, 10):
        rec(13, 1, x, x)


if __name__ == "__main__":
    main()
