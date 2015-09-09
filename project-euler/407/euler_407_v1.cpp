#include <stdio.h>

typedef long long ll;

const ll STEP = 1000;

static inline const ll calc(const ll n)
{
    for (ll x=n-1;x>1;x--)
    {
        if (((x*x) % n) == x)
        {
            return x;
        }
    }
    return 1;
}

int main(int argc, char * argv[])
{
    ll sum = 0;

    ll print_at = STEP;

    for (ll n=2;n<=10000000;n++)
    {
        sum += calc(n);
        if (n == print_at)
        {
            printf ("N=%lld Sum = %lld\n", n, sum);
            fflush(stdout);
            print_at += STEP;
        }
    }

    printf ("Final sum = %lld\n", sum);
    return 0;
}
