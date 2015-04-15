#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

typedef long long ll;
typedef uint32_t u32;
typedef unsigned char byte;

const u32 BASE = 20092010;
const int LEN = 2000;
const int PL = LEN - 1;

struct mat_look_t
{
    u32 c[LEN][LEN];
};

struct Mat
{
    // original and transposed.
    mat_look_t orig, trans;
};

Mat ONE;

static void mul(Mat * ret, const Mat * const m_base, const Mat * const n_base)
{
    const typeof(&(m_base->orig)) m = &(m_base->orig);
    const typeof(&(n_base->trans)) n = &(n_base->trans);

    for (int r = 0 ; r < LEN ; r++)
    {
        const u32 * mi = (m->c[r]);
        for (int c = 0; c < LEN ; c++)
        {
            ll sum = 0;
            const u32 * ni = (n->c[c]);
            for (int i = 0; i < LEN ; i++)
            {
                sum = ((sum + (((ll)mi[i]) * ((ll)ni[i]))) % BASE);
            }
            ret->trans.c[c][r] = ret->orig.c[r][c] = (u32)sum;
        }
    }
}

static void power_helper(ll n, Mat * ret);

static void power(ll n, Mat * ret)
{
    char cache_fn[200];
    snprintf(cache_fn, sizeof(cache_fn), "CACHE/%llX.bin", n);
    FILE * cache_fh = fopen(cache_fn, "rb");
    if (! cache_fh)
    {
        power_helper(n,ret);
        FILE * w = fopen(cache_fn, "wb");
        fwrite(ret, sizeof(*ret), 1, w);
        fclose(w);
        cache_fh = fopen(cache_fn, "rb");
    }
    if (fread(ret, sizeof(*ret), 1, cache_fh) != 1)
    {
        fprintf(stderr, "SNAFU for %lld\n" , n);
        exit(-1);
    }
    fclose(cache_fh);
}

static void power_helper(ll n, Mat * ret)
{
    if (n == 1)
    {
        *ret = ONE;
    }
    else if (n & 0x1)
    {
        Mat * temp_ret = new Mat;
        power ((n ^ 0x1), temp_ret);
        printf ("After rec %lld\n", n);
        fflush(stdout);
        mul(ret, temp_ret, &ONE);
        printf ("After mul %lld\n", n);
        fflush(stdout);
        delete temp_ret;
    }
    else
    {
        Mat * rec = new Mat;
        power(n >> 1, rec);
        printf ("After rec %lld\n", n);
        fflush(stdout);
        mul(ret, rec, rec);
        printf ("After mul %lld\n", n);
        fflush(stdout);
        delete rec;
    }
}

int main()
{
    for (int r = 0 ; r < LEN ; r++)
    {
        for (int c = 0; c < LEN ; c++)
        {
            ONE.trans.c[c][r] = ONE.orig.c[r][c] =
                (
                    (
                            ((r == PL) && (c <= 1))
                            ||
                            ((r < PL) && (r + 1 == c))
                    ) ? 1 : 0
                );
        }
    }

    Mat * p = new Mat;
#if 1
    power( 1000000000000000000LL, p);
#elif 0
    power( 2LL, p);
#else
    power( 4000LL, p);
#endif

    ll sum = 0;

    for (int c = 0; c < LEN ; c++)
    {
        sum = (sum + p->orig.c[0][c]) % BASE;
    }

    printf ("Result = %lld\n", sum);

    delete p;
    return 0;
}
