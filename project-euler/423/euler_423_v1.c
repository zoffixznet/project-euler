#include <stdio.h>

typedef long long LL;
const LL MOD = 1000000007;

int primes[3001135];
int * p_p;

LL s_n = 0;

#define lim 50000000
#define after_lim (lim+1)

LL one[after_lim], two[after_lim];

LL * current , * next, * temp;

int main()
{
    FILE * f = fopen ("primes.txt", "rt");

    p_p = primes;
    while (fscanf(f, "%d\n", p_p) == 1)
    {
        p_p++;
    }
    *(p_p) = -1;
    p_p = primes;

    fclose(f);

    one[0] = 6;
    one[1] = 0;
    current = one;
    next = two;
    int pi = 0;

    for (int n=1;n<after_lim; n++)
    {
        next[0] = (5 * current[0]) % MOD;
        for (int i = 1; i <= n; i++)
        {
            next[i] = ((current[i]*5+current[i-1]) % MOD);
        }
        next[n+1] = 0;

        if (*(p_p) == n)
        {
            pi++;
            p_p++;
        }

        LL C = 0;
        for (int i = 0; i <= pi; i++)
        {
            C += current[i];
        }
        s_n = ((s_n + C) % MOD);
        printf ("C(%d) = %lld; S = %lld\n", n, C, s_n);

        {
            temp = current;
            current = next;
            next = temp;
        }
    }

    return 0;
}
