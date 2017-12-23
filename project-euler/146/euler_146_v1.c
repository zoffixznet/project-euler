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
#include <stdbool.h>
#include <math.h>

#define DIV 9699690
#define NUM_MODS 24024
#define NUM_PRIMES 8497392

int primes[NUM_PRIMES];
int mods[NUM_MODS];

typedef long long LL;

static inline bool is_prime(LL n)
{
    LL lim = (LL)(sqrt(n));

    for (int p_idx=0; p_idx < NUM_PRIMES ; p_idx++)
    {
        typeof (primes[p_idx]) p = primes[p_idx];
        if (p > lim)
        {
            return true;
        }
        if (n % p == 0)
        {
            return false;
        }
    }
    return true;
}

int y_off[6] = {1,3,7,9,13,27};
int n_off[8] = {5,11,15,17,19,21,23,25};

#if 1
#define LIMIT 150000000
#else
#define LIMIT 1000000
#endif

int main(int argc, char * argv[])
{
    /* Read primes and mods. */

    {
        FILE * f = fopen("primes-c.txt", "r");
        for (int i=0; i < NUM_PRIMES; i++)
        {
            fscanf(f, "%d", &(primes[i]));
        }
        fclose(f);
    }

    {
        FILE * f = fopen("db-c.txt", "r");
        for (int i=0; i < NUM_MODS; i++)
        {
            fscanf(f, "%d", &(mods[i]));
        }
        fclose(f);
    }

    LL sum = 0;

    for (int offset = 0 ; ; offset += DIV)
    {
        for (int m_idx=0;m_idx< NUM_MODS;m_idx++)
        {
            int n = offset + mods[m_idx];
            if (n > LIMIT)
            {
                goto after_main;
            }

            LL sq = n;
            sq *= sq;

            for (int y_idx=0;y_idx<sizeof(y_off)/sizeof(y_off[0]);y_idx++)
            {
                if (! is_prime(sq + y_off[y_idx]))
                {
                    goto fail;
                }
            }
            for (int n_idx=0;n_idx<sizeof(n_off)/sizeof(n_off[0]);n_idx++)
            {
                if (is_prime(sq + n_off[n_idx]))
                {
                    goto fail;
                }
            }
            printf ("Found N=%i\n", n);
            fflush (stdout);
            sum += n;
fail:
            ;
        }
    }
after_main:

    printf ("Sum = %lld\n", sum);

    return 0;
}
