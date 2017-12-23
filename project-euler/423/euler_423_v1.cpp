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
#include <stdlib.h>
#include <string.h>
#include <iostream>

#define min(a,b) (((a)<(b))?(a):(b))

typedef long long LL;
typedef unsigned int ui;
#define MOD_PROTO 1000000007
const ui MOD = MOD_PROTO;

ui * lookup_5_prod_mods = NULL;
#define NUM_PRIMES_MIN_1 3001134
#define NUM_PRIMES (NUM_PRIMES_MIN_1 + 1)

int primes[NUM_PRIMES];
int * p_p;
int next_p;

ui s_n = 0;

#define lim 50000000
#define after_lim (lim+1)

ui one[NUM_PRIMES+1], two[NUM_PRIMES+1];

ui * current , * next, * temp;

const int DUMP_STEP = 10000;

int dump_at;

int main()
{
    {
        lookup_5_prod_mods = (ui *)malloc(sizeof(lookup_5_prod_mods[0]) * MOD);
        ui m = 0;
        for (ui i = 0 ; i < MOD; i++)
        {
            lookup_5_prod_mods[i] = m;
            if ((m += 5) >= MOD)
            {
                m -= MOD;
            }
        }
    }
    dump_at = DUMP_STEP;
    FILE * f = fopen ("primes.txt", "rt");

    p_p = primes;
    while (fscanf(f, "%d\n", p_p) == 1)
    {
        p_p++;
    }
    *(p_p) = -1;
    next_p = *(p_p = primes);

    fclose(f);

    memset(one, '\0', sizeof(one));
    memset(two, '\0', sizeof(two));

    one[0] = one[1] = one[2] = 6;
    current = one;
    next = two;
    int pi = 0;

    int n = 1;
    int prev_n = 1;
    while (1)
    {
        char fn[300];
        sprintf(fn, "DUMPS/%d.bin", dump_at);

        FILE * fh = fopen(fn, "rb");

        if (! fh)
        {
            n = prev_n;
            break;
        }
        fread (&s_n, sizeof(s_n), 1, fh);
        fread (current, sizeof(*current), sizeof(one)/sizeof(one[0]), fh);

        fclose(fh);

        dump_at += DUMP_STEP;
        prev_n = n;
        n = dump_at;
    }

    /* Restore p_p */
    for (int i = 1; i <= n; i++)
    {
        if (*(p_p) == i)
        {
            pi++;
            p_p++;
        }
    }
    next_p = *(p_p);
    for (; n < after_lim ; n++)
    {
        if (dump_at == n)
        {
            char fn[300];
            sprintf(fn, "DUMPS/%d.bin", dump_at);
            FILE * fh = fopen(fn, "wb");
            fwrite (&s_n, sizeof(s_n), 1, fh);
            fwrite (current, sizeof(*current), sizeof(one)/sizeof(one[0]), fh);
            fclose(fh);
            dump_at += DUMP_STEP;
        }
        next[0] = lookup_5_prod_mods[current[0]];
        const int my_top_idx = min(n, NUM_PRIMES_MIN_1);
        int i;
        for (i = 1; i <= my_top_idx; i++)
        {
            const ui my_next = lookup_5_prod_mods[current[i]] + current[i-1];
            next[i] = my_next >= MOD ? my_next - MOD : my_next;
        }
        next[i] = next[i-1];

        if (next_p == n)
        {
            pi++;
            next_p = *(++p_p);
        }

        const ui C = current[pi];
        if ((s_n += C) >= MOD)
        {
            s_n -= MOD;
        }
        std::cout << "C(" << n << ") = " << C << "; S = " << s_n << std::endl;

        {
            temp = current;
            current = next;
            next = temp;
        }
    }

    return 0;
}
