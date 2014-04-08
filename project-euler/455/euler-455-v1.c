#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef long long myint_t;

/*
=head1 DESCRIPTION

Let f(n) be the largest positive integer x less than 109 such that the last 9 digits of nx form the number x (including leading zeros), or zero if no such integer exists.

For example:

    f(4) = 411728896 (4411728896 = ...490411728896)
    f(10) = 0
    f(157) = 743757 (157743757 = ...567000743757)
    Σf(n), 2 ≤ n ≤ 103 = 442530011399

Find Σf(n), 2 ≤ n ≤ 106.

=cut

*/

const myint_t MOD = 1000000000;

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

int main(int argc, char * argv[])
{
    myint_t START = 999997951;
    myint_t SEGMENT = 1024;

    const char const * DUMP_FN = "euler-455.txt";

    myint_t sum = 0;
    // Every n^e where e > 2 will have more zeros than needed.
    //
    const int max_n = 1000000;
    const int min_n = 2;
    const int vec_size = (max_n+1) >> 3;
    char n_s_bit_vec[vec_size];

    memset(n_s_bit_vec, '\0', vec_size);

    for (int n = min_n; n<= max_n; n++)
    {
        if (n % 10)
        {
            n_s_bit_vec[n >> 3] |= (1 << (n&(8-1)));
        }
    }

    {
        FILE * in = fopen(DUMP_FN, "rt");
        char l[4000];
        while (fgets(l, sizeof(l), in))
        {
            myint_t x, n;

            if (sscanf(l, "Found x=%lld for n=%lld", &x, &n))
            {
                sum += x;
                n_s_bit_vec[n >> 3] &= ~((char)(1 << (n&(8-1))));
            }
            else
            {
                sscanf(l, "Inspecting %lld", &START);
            }
        }
        fclose (in);

    }

    typedef struct
    {
        int count;
        int elems[max_n];
    } n_s_t;

    n_s_t proto_n_s[2];

    n_s_t * n_s = &(proto_n_s[0]);
    n_s_t * next_n_s = &(proto_n_s[1]);

    n_s->count = next_n_s->count = 0;
    for (int n = min_n; n<= max_n; n++)
    {
        if (n_s_bit_vec[n >> 3] & (1 << (n & (8-1))))
        {
            n_s->elems[n_s->count++] = n;
        }
    }
    myint_t range_top = START;

    FILE * out_fh = fopen(DUMP_FN, "at");
    while (range_top > SEGMENT)
    {
        fprintf(out_fh, "Inspecting %lld\n", range_top);
        fflush(out_fh);

        const myint_t bottom = range_top - (SEGMENT - 1);

        const int n_s_count = n_s->count;
        const int * const n_s_elems = n_s->elems;

        int next_n_s_count = next_n_s->count;
        int * const next_n_s_elems = next_n_s->elems;

        for (int n_idx = 0; n_idx < n_s_count ; n_idx++)
        {
            int n = n_s_elems[n_idx];
            myint_t e = bottom;
            myint_t m = exp_mod(n, e);
            myint_t found_e = -1;
            while (e <= range_top)
            {
                if (m == e)
                {
                    found_e = e;
                }
                m = ((m * n) % MOD);
                e++;
            }

            if (found_e >= 0)
            {
                fprintf(out_fh, "Found x=%lld for n=%d\n", found_e, n);
                fflush(out_fh);
                sum += found_e;
            }
            else
            {
                next_n_s_elems[next_n_s_count++] = n;
            }
        }
        next_n_s->count = next_n_s_count;

        {
            n_s_t * const prev_n_s = n_s;
            n_s = next_n_s;
            next_n_s = prev_n_s;
            next_n_s->count = 0;
        }
        range_top -= SEGMENT;
    }
    fclose(out_fh);

    fprintf(stdout, "Sum == %lld\n", sum);

    return 0;
}

