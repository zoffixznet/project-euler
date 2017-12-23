// The Expat License
//
// Copyright (c) 2017, Shlomi Fish
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
