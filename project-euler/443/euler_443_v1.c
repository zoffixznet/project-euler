#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

typedef unsigned long long ll;

static inline ll gcd(ll n, ll m)
{
    while (m > 0)
    {
        const ll new_m = n%m;
        n = m;
        m = new_m;
    }
    return n;
}

int main(int argc, char * argv[])
{
    const ll TARGET = atoll(argv[1]);
    ll g = 13;
    for (ll n = 5 ; n <= TARGET ; n++)
    {
        g += gcd(g, n);
        if ((n & ((1 << 20)-1)) == 0)
        {
            printf ("g[%lld] = %lld\n", (long long)n, (long long)g);
        }
    }
    printf ("g[%lld] = %lld\n", (long long)TARGET, (long long)g);

    return 0;
}
