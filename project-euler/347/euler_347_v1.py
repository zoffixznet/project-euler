import sys
from bigfloat import precision, BigFloat

if sys.version_info > (3,):
    long = int
    xrange = range


def main():
    primes = []
    with open('primes.txt') as f:
        for l in f:
            primes.append(long(l))
    # print(primes)
    LIM = 10000000
    # LIM = 100
    ret = long(0)
    for p_idx, p in enumerate(primes):
        print("Reached (%d,%d)" % (p_idx,p))
        if p * primes[p_idx+1] > LIM:
            break
        for q_idx in xrange(p_idx+1,len(primes)):
            q = primes[q_idx]
            prod = p * q
            if prod > LIM:
                break
            mymax = prod
            prod1 = prod
            while prod1 <= LIM:
                prod2 = prod1
                prev = prod2
                while prod2 <= LIM:
                    prev = prod2
                    prod2 *= p
                if prev > mymax:
                    mymax = prev
                prod1 *= q
            # print("M(%d,%d) = %d" % (p,q,mymax))
            ret += mymax
    print("Result = %d" % ret)


if __name__ == "__main__":
    main()
