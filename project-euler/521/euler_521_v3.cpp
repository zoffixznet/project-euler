#include <stdio.h>
#include <string.h>

typedef unsigned __int128 ll;

const ll first_primes[9] = {2,3,5,7,11,13,17,19,23};
const ll SIZ = 2*3*5*7*11*13*17*19*23;

const ll aft_first_p = 29;
const ll LIMIT = 1000000000000LL;
const ll SQUARE_ROOT_LIMIT = 1000000LL;
const ll MOD = 1000000000LL;

const int NUM_PRIMES = 78500;
bool cache[SIZ];

struct aft_prime_t
{
    ll p, product;
};

aft_prime_t aft_primes[NUM_PRIMES];
unsigned __int128 sum;

static bool update(const size_t i, const ll smpf, const ll prod)
{
    if (prod > LIMIT)
    {
        return false;
    }
    sum += smpf - prod;
    update(i, smpf, prod*aft_primes[i].p);
    for (size_t j=i+1;j<NUM_PRIMES;j++)
    {
        if (! update(j, smpf, prod*aft_primes[j].p))
        {
            break;
        }
    }
    return true;
}
int main()
{
    char cmd[100];
    snprintf(cmd, sizeof(cmd), "primesieve -p %lld %lld", (long long)aft_first_p, (long long)(2*SQUARE_ROOT_LIMIT));

    FILE * f = popen(cmd, "r");

    for (int i = 0; i < NUM_PRIMES ; i++)
    {
        long long p;
        fscanf(f, "%lld", &p);
        aft_primes[i].p = p;
        aft_primes[i].product = aft_primes[i].p;
    }
    pclose(f);

    memset(cache, '\0', sizeof(cache));

    sum = (LIMIT-1)*(LIMIT+2)/2;
    for (size_t p_idx = 0 ; p_idx < sizeof(first_primes)/sizeof(first_primes[0]) ; p_idx++)
    {
        auto p = first_primes[p_idx];
        size_t i_delta = (size_t)p;
        unsigned char p_to_assign = (unsigned char)p;

        size_t i = p;
        while (i < SIZ)
        {
            if (! cache[i])
            {
                cache[i] = true;
                const ll e1 = ((LIMIT / SIZ) * SIZ + i);
                const ll e2 = e1 > LIMIT ? e1-SIZ : e1;
                sum += ((e2-i) / SIZ + 1) * p_to_assign - ((e2-i)/SIZ + 1)*(e2+i)/2;
            }
            i += i_delta;
        }
    }
    for (size_t p_idx = 0 ; p_idx < sizeof(aft_primes)/sizeof(aft_primes[0]) ; p_idx++)
    {
        update(p_idx, aft_primes[p_idx].p, aft_primes[p_idx].p);
        printf("Reached %lld sum=%lld\n", (long long)p_idx, (long long)(sum % MOD));
    }

    printf("FinalReached %lld sum=%lld\n", 0LL, (long long)(sum % MOD));

    return 0;
}
