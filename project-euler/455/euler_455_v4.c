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
        ret %= MOD;
        ret *= b;
    }

    return (ret % MOD);
}

#define CYCLE_LEN 50000000
/* Found out experimentally for all numbers in the range. */
#define CYCLE_LEN_DELTA_BASE 8
/* A safety margin. */
#define CYCLE_LEN_DELTA_MARGIN 3
#define CYCLE_LEN_DELTA (CYCLE_LEN_DELTA_BASE + CYCLE_LEN_DELTA_MARGIN)
#define NEXT_POWER() { power = ((power * rainbow_mod) % MOD); }

#define RAINBOW_MOD 10000
static int rainbow_table[RAINBOW_MOD];

static inline myint_t calc_f(myint_t n)
{
    myint_t x = 0;
    if (n % 10 != 0)
    {
        const myint_t rainbow_mod = exp_mod(n, RAINBOW_MOD);
        const int rainbow_val = rainbow_table[n % RAINBOW_MOD];

        int e = rainbow_val;
        myint_t power = exp_mod(n, e);
        for (; e < (CYCLE_LEN) ; e+= RAINBOW_MOD)
        {
            /* Put the cheaper conditional first. */
            if (( power > x ) && (power % CYCLE_LEN == e))
            {
                x = power;
            }
            NEXT_POWER();
        }
        if (( power > x ) && (power % CYCLE_LEN == (e - CYCLE_LEN)))
        {
            x = power;
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

    {
        FILE * fh = fopen("rainbow_table.txt", "rt");

        char line[800];
        while (fgets(line, sizeof(line), fh))
        {
            int mod;
            int rainbow_val;
            if (sscanf(line, "mod=%d --> %d\n", &mod, &rainbow_val) != 2)
            {
                fprintf(stderr, "Wrong line. <<%s>>", line);
                exit(-1);
            }
            rainbow_table[mod] = rainbow_val;
        }
        fclose(fh);
    }

    myint_t sum = 0;
    for (myint_t n = START; n <= END ; n++)
    {
        sum += calc_f(n);
    }
    printf( "Sum == %lld\n", sum);
    fflush(stdout);
    return 0;
}

