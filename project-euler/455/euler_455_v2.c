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
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef long long myint_t;

#define MOD 1000000000

static inline myint_t exp_mod(myint_t b, myint_t e)
{
    if (e == 0)
    {
        return 1;
    }

    const myint_t rec_p = exp_mod(b, (e >> 1));

    myint_t ret = rec_p * rec_p;

    if (e & 0x1)
    {
        ret *= b;
    }

    return (ret % MOD);
}

// This assumes an 8-bit byte.
static char cache[(MOD >> 3) + 1];

#define NEXT_POWER() { power = ((power * n) % MOD); }

static inline myint_t calc_f(myint_t n)
{
    myint_t x = 0;
    if (n % 10 != 0)
    {
        memset(cache, '\0', sizeof(cache));
        myint_t e = 0;
        myint_t power = 1;

        // Find the first cycle len.
        while (! ( cache[power>>3] & (1 << (power&(8-1)))))
        {
            cache[power >> 3] |= (1 << (power&(8-1)));
            e++;
            NEXT_POWER();
        }

        const myint_t found_power = power;
        const myint_t found_e = e;

        power = 1;
        e = 0;
        while (power != found_power)
        {
            e++;
            NEXT_POWER();
        }

        myint_t cycle_len = found_e - e;

        power = 1;
        for (myint_t e2=0; e2 <= found_e; e2++)
        {
            if (((power - e2) % cycle_len == 0)
                && ( power > x )
            )
            {
                x = power;
            }
            NEXT_POWER();
        }
    }

    printf("f(%lld) == %lld\n", n, x);
    fflush(stdout);

    return x;
}

int main(int argc, char * argv[])
{
    const myint_t START = atol(argv[1]);
    const myint_t END = atol(argv[2]);

    myint_t sum = 0;
    for (myint_t n = START; n <= END ; n++)
    {
        sum += calc_f(n);
    }
    printf( "Sum == %lld\n", sum);
    fflush(stdout);
    return 0;
}

