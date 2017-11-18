#include <stdio.h>
#include <string.h>

typedef long long ll;

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

int main(int argc, char * argv[])
{
    char cmd[100];
    snprintf(cmd, sizeof(cmd), "primesieve -p %lld %lld", aft_first_p, 2*SQUARE_ROOT_LIMIT);

    FILE * f = popen(cmd, "r");

    for (int i = 0; i < NUM_PRIMES ; i++)
    {
        fscanf(f, "%lld", &(aft_primes[i].p));
        aft_primes[i].product = aft_primes[i].p;
    }
    pclose(f);

    memset(cache, '\0', sizeof(cache));
    unsigned __int128 sum = 0;

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
                sum += ((e2-i) / SIZ + 1) * p_to_assign;
                sum %= MOD;
            }
            i += i_delta;
        }
    }

    ll start = 0;
    ll offset = 2;
    ll end = start + SIZ;

    ll n = start + offset;
    --offset;


    size_t max_p_idx = 0;

    while (1)
    {
        {
            auto p = aft_primes[max_p_idx].p;
            while (p*p < end)
            {
                p = aft_primes[++max_p_idx].p;
            }
        }

        while (n < end)
        {
            if (n > LIMIT)
            {
                goto my_end;
            }
            if (! cache[++offset])
            {
                ll smpf = 0;
                for (size_t p_idx = 0 ; p_idx < max_p_idx ; p_idx++)
                {
                    auto & p = aft_primes[p_idx];
                    while (p.product < n)
                    {
                        p.product += p.p;
                    }
                    if (p.product == n)
                    {
                        smpf = p.p;
                        break;
                    }
                }
                if (! smpf)
                {
                    smpf = n;
                }

                sum += smpf;
            }
            n++;
        }
        start = end;
        end += SIZ;
        offset = -1;
        printf("Reached %lld sum=%lld\n", start, (ll)(sum % MOD));
    }

my_end:
    printf("FinalReached %lld sum=%lld\n", start, (ll)(sum % MOD));

    return 0;
}
