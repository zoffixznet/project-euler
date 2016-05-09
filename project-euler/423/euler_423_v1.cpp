#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

ui s_n = 0;

#define lim 50000000
#define after_lim (lim+1)

ui one[NUM_PRIMES], two[NUM_PRIMES];

ui * current , * next, * temp;

const int DUMP_STEP = 100000;

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
    p_p = primes;

    fclose(f);

    memset(one, '\0', sizeof(one));
    memset(two, '\0', sizeof(two));

    one[0] = one[1] = one[2] = 6;
    current = one;
    next = two;
    int pi = 0;

    int was_set = 0;
    int n = 1;
    int prev_n = 1;
#if 0
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
        if (! was_set)
        {
            {
                temp = current;
                current = next;
                next = temp;
            }
            was_set = 1;
        }
        fread (current, sizeof(*current), sizeof(one)/sizeof(one[0]), fh);

        fclose(fh);

        dump_at += DUMP_STEP;
        prev_n = n;
        n = dump_at;
    }
#endif

    /* Restore p_p */
    for (int i = 1; i <= n; i++)
    {
        if (*(p_p) == i)
        {
            pi++;
            p_p++;
        }
    }
    for (; n < after_lim ; n++)
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
        next[0] = lookup_5_prod_mods[current[0]];
        const int my_top_idx = min(n, NUM_PRIMES_MIN_1);
        int i;
        for (i = 1; i <= my_top_idx; i++)
        {
            const ui my_next = lookup_5_prod_mods[current[i]] + current[i-1];
            next[i] = my_next >= MOD ? my_next - MOD : my_next;
        }
        next[i] = next[i-1];

        if (*(p_p) == n)
        {
            pi++;
            p_p++;
        }

#if 0
        LL C = 0;
        for (int i = 0; i <= pi; i++)
        {
            C += current[i];
        }
#else
        const ui C = current[pi];
#endif
        if ((s_n += C) >= MOD)
        {
            s_n -= MOD;
        }
        printf ("C(%d) = %lld; S = %lld [pi=%d]\n", n, C, s_n, pi);

        {
            temp = current;
            current = next;
            next = temp;
        }
    }

    return 0;
}
