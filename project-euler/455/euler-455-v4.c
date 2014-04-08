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

