#include <cstdio>

typedef long long ll;

ll calc_SIGMA2_mod(const ll MOD, const ll n)
{
    ll sq = 1;
    ll d = 3;
    ll r = 0;
    const ll lim = MOD < (n+1) ? MOD : (n+1);
    for (ll i=1; i < lim; ++i)
    {
        if (sq != 0)
        {
            ll j = i;
            ll jdiv = n / j;
            ll t = 0;
            while (jdiv > 1)
            {
                t = ((t + jdiv) % MOD);
                j += MOD;
                jdiv = n / j;
            }
            r = ((r + sq * (t + ((j <= n) ? ((1 + (n - j) / MOD) % MOD) : 0)))
                 % MOD);
        }
        sq = ((sq+d) % MOD);
        d += 2;
        if (i % 1000 == 0)
        {
            printf("Reached i=%lld ret=%lld\n", i, r);
#if 1
            fflush(stdout);
#endif
        }
    }
    return r;
}


int main()
{
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 1));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 2));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 3));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 4));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 5));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 6));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000000000LL, 1000000000000000LL));

    return 0;
}
