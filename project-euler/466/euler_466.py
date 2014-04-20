# Written by Lucy_Hedgehog on the forum.
#
# Description:
#
# From counting primes I know how to find the number of integers < m not
# divisible by any divisor from a set S of pairwise coprime integers. For this
# problem I was looking for a similar solution without the condition that the
# elements in S are pairwise coprime. This needs 2.3 seconds and very little
# memory.

import subprocess
import sys

def gcd(n,m):
    if m > n:
        n, m = m, n

    while m > 0:
        n, m = m, n%m

    return n

def all_primes(n):
    return map(long,subprocess.check_output(["primes", "2", str(n)]).split('\n')[0:-2])

Primes = all_primes(64)

def ndiv_coprime(N,L,i):
    '''return the number of integers in the range
       1..m not divisible by any integer in L[0:i].
       The integer in L must be pairwise coprime.
       L is sorted in descending order'''
    if i==0 or N < L[i-1]: return N
    res = N
    for j in range(i):
        res -= ndiv_coprime(N//L[j],L,j)
    return res

tab = {}
def ndiv(m,S):
    '''return the number of integers in the range
       1..m not divisible by any integer in S'''
    if len(S) == 0: return m
    # Remove redundant elements from S
    R = set()
    for x in S:
        for y in S:
            if x>y and x%y==0: break
        else: R.add(x)
    # search for a prime factor occuring multiple times in R
    for p in Primes:
        D = [x for x in R if x%p==0]
        if len(D) > 1:
            C = [x for x in R if x%p != 0]
            B = [x//p for x in D]
            # count integers not divisible by p
            A1 = ndiv(m,C) - ndiv(m//p,C)
            # count integers divisible by p
            A2 = ndiv(m//p,B+C)
            return A1+A2
    # The integers in R are pairwise coprime.
    L = list(R)
    L = sorted(L)[::-1]
    T = tuple(L)
    if (T,m) in tab: return tab[T,m]
    res =  ndiv_coprime(m,L,len(L))
    tab[T,m] = res
    return res


def P466(n,m):
    assert 2*max(Primes) >= n
    res = 0
    for i in range(1,n+1):
        # Count the number of integers i, 2*i, ... m*i, which are not
        # divisible by an integer in the range i+1 .. n
        L = set(j // gcd(i,j) for j in range(i+1,n+1))
        C = ndiv(m, L)
        res += C
    return res

def main():
    print "Result == ", P466(long(sys.argv[1]), long(sys.argv[2]))
    return

if __name__ == "__main__":
    main()
