import sys

if sys.version_info > (3,):
    long = int
    xrange = range

LIM = 10000000000


def find_pivots(m):
    k = m+1
    s_k = 0
    for i in xrange(-m, 0+1):
        s_k += (k+i)*(k+i)
    k_m = k - m
    n = m
    s_n = 0
    for i in xrange(-m+1, 0+1):
        s_n += (n+i)*(n+i)
    n_m = n - m + 1
    while k <= LIM:
        if k % 10000000 == 0:
            print("Reached %d" % k)
        while s_n < s_k:
            n += 1
            n_m += 1
            s_n += n*n-n_m*n_m
        if s_n == s_k and n > k:
            print("Found %d" % k)
        k += 1
        k_m += 1
        s_k += k*k-k_m*k_m


def main():
    find_pivots(2)
    # print("Result = %d" % calc_G((n*n*n for n in xrange(1, 1000000))))


if __name__ == "__main__":
    main()
