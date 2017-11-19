#include <stdio.h>
#include <string.h>
#include <string>

typedef unsigned __int128 ll;

const ll first_primes[9] = {2,3,5,7,11,13,17,19,23};
const ll SIZ = 2*3*5*7*11*13*17*19*23;

const ll aft_first_p = 29;
#if 0
const ll LIMIT = 1000000000000LL;
#else
const ll LIMIT = 29004959LL;
#endif
const ll SQUARE_ROOT_LIMIT = 1000000LL;
const ll MOD = 1000000000LL;

const int NUM_PRIMES = 78500;
bool cache[SIZ];

typedef ll aft_prime_t;

aft_prime_t aft_primes[NUM_PRIMES];
unsigned __int128 sum;

static bool update(const size_t i, const ll smpf, const ll prod)
{
    if (prod > LIMIT)
    {
        return false;
    }
#if 0
    printf("U=%lld\n", (long long)prod);
#endif
    sum += smpf - prod;
    for (size_t j=i;j<NUM_PRIMES;j++)
    {
        if (! update(j, smpf, prod*aft_primes[j]))
        {
            break;
        }
    }
    return true;
}

std::string ll2s(const ll n)
{
    char s[2] = {0,0};
    if (n == 0)
    {
        return std::string("");
    }
    s[0] = '0' + n % 10;
    return ll2s(n / 10) + std::string(s);
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
        aft_primes[i] = p;
    }
    pclose(f);

    memset(cache, '\0', sizeof(cache));

    sum = (LIMIT-1)*(LIMIT+2)/2;
        {
        std::string s = ll2s(sum);
        printf("StrReached %lld sum = %s\n", (long long)SIZ, s.c_str());
        }
    for (size_t p_idx = 0 ; p_idx < sizeof(first_primes)/sizeof(first_primes[0]) ; p_idx++)
    {
        const auto p = first_primes[p_idx];
        const size_t i_delta = (size_t)p;

        size_t i = 0;
        while (i < SIZ)
        {
            if (! cache[i])
            {
                cache[i] = true;
                const ll e1 = ((LIMIT / SIZ) * SIZ + i);
                {
                    const ll e2 = e1 > LIMIT ? ( e1<SIZ ? i : e1-SIZ ): e1;
                    if (e2 <= LIMIT)
                    {
                    const ll s = i == 0 ? i+SIZ : i;
                    if (s <= LIMIT)
                    {
                    sum += ((e2-s) / SIZ + 1) * p - ((e2-s)/SIZ + 1)*(e2+s)/2;
                    }
                    }
                }
            }
            i += i_delta;
        }
#if 1
                {
                    std::string s = ll2s(sum);
                    printf("FloReached %lld sum = %s\n", (long long)p, s.c_str());
                }
#endif
    }
    for (size_t p_idx = 0 ; p_idx < sizeof(aft_primes)/sizeof(aft_primes[0]) ; p_idx++)
    {
        {
        std::string s = ll2s(sum);
        printf("BefReached %lld sum = %s\n", (long long)aft_primes[p_idx], s.c_str());
        }
        update(p_idx, aft_primes[p_idx], aft_primes[p_idx]);
        std::string s = ll2s(sum);
        printf("AftReached %lld sum = %s\n", (long long)aft_primes[p_idx], s.c_str());
    }

    printf("FinalReached %lld sum = %lld\n", 0LL, (long long)(sum % MOD));

    return 0;
}
