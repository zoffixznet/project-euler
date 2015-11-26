#include <stdio.h>

#define min(a,b) (((a)<(b))?(a):(b))

typedef long long LL;
const LL MOD = 1000000007;

#define NUM_PRIMES_MIN_1 3001134
#define NUM_PRIMES (NUM_PRIMES_MIN_1 + 1)

int primes[NUM_PRIMES];
int * p_p;

LL s_n = 0;

#define lim 50000000
#define after_lim (lim+1)

LL one[NUM_PRIMES], two[NUM_PRIMES];

LL * current , * next, * temp;

const int DUMP_STEP = 100000;

int dump_at;

int main()
{
    dump_at = DUMP_STEP;
    FILE * f = fopen ("primes.txt", "rt");

    p_p = primes;
    while (fscanf(f, "%d\n", p_p) == 1)
    {
        p_p++;
    }
    *(p_p) = -1;
    p_p = primes;

    fclose(f);

    one[0] = 6;
    one[1] = 0;
    current = one;
    next = two;
    int pi = 0;

    for (int n=1 ; n < after_lim ; n++)
    {
        if (dump_at == n)
        {
            char fn[300];
            sprintf(fn, "DUMPS/%d.bin", dump_at);
            FILE * fh = fopen(fn, "wb");
            fwrite (current, sizeof(*current), sizeof(one)/sizeof(one[0]), fh);
            fclose(fh);
            dump_at += DUMP_STEP;
        }
        next[0] = (5 * current[0]) % MOD;
        const int my_top_idx = min(n, NUM_PRIMES_MIN_1);
        for (int i = 1; i <= my_top_idx; i++)
        {
            next[i] = ((current[i]*5+current[i-1]) % MOD);
        }
        next[my_top_idx+1] = 0;

        if (*(p_p) == n)
        {
            pi++;
            p_p++;
        }

        LL C = 0;
        for (int i = 0; i <= pi; i++)
        {
            C += current[i];
        }
        s_n = ((s_n + C) % MOD);
        printf ("C(%d) = %lld; S = %lld\n", n, C, s_n);

        {
            temp = current;
            current = next;
            next = temp;
        }
    }

    return 0;
}
