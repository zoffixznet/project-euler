#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>

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
        typeof(&(m->c[r])) mi = &(m->c[r]);
        for (int c = 0; c < LEN ; c++)
        {
            ll sum = 0;
            typeof(&(n->c[c])) ni = &(n->c[c]);
            for (int i = 0; i < LEN ; i++)
            {
                sum = (sum + (((ll)mi[i]) * ((ll)ni[i]))) % BASE;
            }
            ret->trans.c[c][r] = ret->orig.c[r][c] = (u32)sum;
        }
    }
}

void power(ll n, Mat * ret)
{
    if (n == 1)
    {
        *ret = ONE;
    }
    else
    {
        Mat * rec = new Mat;
        power(n >> 1, rec);
        printf ("After rec %lld\n", n);
        fflush(stdout);
        if (n & 0x1)
        {
            Mat * temp_ret = new Mat;
            mul(temp_ret, rec, rec);
            mul(ret, temp_ret, &ONE);
            delete temp_ret;
        }
        else
        {
            mul(ret, rec, rec);
        }
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
    power( 1000000000000000000LL, p);

    ll sum = 0;

    for (int c = 0; c < LEN ; c++)
    {
        sum = (sum + p->orig.c[0][c]) % BASE;
    }

    printf ("Result = %lld\n", sum);

    delete p;
    return 0;
}
