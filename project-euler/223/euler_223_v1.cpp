#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <math.h>

typedef long long ll;

typedef unsigned char byte;

const ll LIM = 25000000;

int main()
{
    // For the case where A = 1.
    ll count = (int)sqrt((LIM-1)/2);
    ll As = 4;
    ll Ad = 3;
    ll l = LIM/3;
    for (ll A=2; A <= l; A++, As += (Ad += 2))
    {
        printf("Checking A=%lld\n", A);
        ll Cs = ((As<<1)-1);
        ll Bd = Ad;
        for (ll B=A; B <= l ; B++, Cs += (Bd += 2))
        {
            ll C = (ll)(sqrt(Cs));
            if (A+B+C > LIM)
            {
                break;
            }
            if (C*C == Cs)
            {
                printf ("Found (%lld,%lld,%lld) %lld\n",
                    A, B, C, ++count
                );
            }
        }
    }
    printf ("Final count=%lld\n", count);

    return 0;
}
