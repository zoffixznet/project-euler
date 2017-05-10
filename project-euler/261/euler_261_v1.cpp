#include <set>
#include <array>
#include <cstdio>
#include <set>

typedef unsigned __int128 ll;

const ll LIM = 10000000000;

void find_pivots(const ll m)
{
    ll s_k = 0;
    ll k = m+1;
    ll k_m = 1;
    for (ll i = k_m; i <= k; i++)
    {
        s_k += i*i;
    }
    ll n = m;
    ll n_m = 1;
    ll s_n = 0;
    for (ll i = n_m; i <= n; i++)
    {
        s_n += i*i;
    }
    while (k <= LIM)
    {
        if (k % 10000000 == 0)
        {
            printf("Reached %lld\n", (long long)k);
        }
        while (s_n < s_k)
        {
            ++n;
            ++n_m;
            s_n += n*n-n_m*n_m;
        }
        if ((s_n == s_k) && (n > k))
        {
            printf("Found %lld\n", (long long)k);
        }
        ++k;
        ++k_m;
        s_k += k*k-k_m*k_m;
    }
}

int main()
{
    find_pivots(2);
    return 0;
}
