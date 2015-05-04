#include <string.h>
#include <stdio.h>

typedef long long ll;
#if 0
const int L = 10000000-1;
#else
const ll L = 2000000000-1;
#endif

unsigned char v[(L >> 3) + 1];
unsigned char v2[(L >> 3) + 1];

int main(int argc, char * argv[])
{
    memset(v, '\0', sizeof(v));

    ll dx = 1;
    for (ll xs = 1; xs < L; xs += (dx += 2))
    {
        printf("Reached xs=%lld\n", xs);
        ll dy = dx;
        for (ll xys=(xs<<1); xys <= L; xys += (dy += 2))
        {
            v[xys >> 3] |= (1 << (xys & 0x7));
        }
    }

    unsigned char * o = v;
    unsigned char * t = v2;

    memset(t, '\0', sizeof(v));

    const ll f_s[4] = {2,3,7,0};
    for (ll f_idx=0;f_idx<3;f_idx++)
    {
        const ll f = f_s[f_idx];
        const ll ddy = (f<<1);
        ll dx = 1;
        for (ll xs = 1; xs < L; xs += (dx += 2))
        {
            printf("Reached f=%lld xs=%lld\n", f, xs);
            ll dy = f;
            for (ll xys=xs+dy; xys <= L; xys += (dy += ddy))
            {
                const ll byte = xys >> 3;
                const ll bit = (1 << (xys & 0x7));
                if (o[byte] & bit)
                {
                    t[byte] |= bit;
                }
            }
        }

        if (o == v)
        {
            o = v2;
            t = v;
        }
        else
        {
            o = v;
            t = v2;
        }
        memset(t, '\0', sizeof(v));
    }

    {
        ll c = 0;
        for (ll n = 2 ; n <= L ; n++)
        {
            if (o[n >> 3] & (1 << (n&0x7)))
            {
                printf( "Found %lld\n", (++c));
            }
        }
    }

    return 0;
}
