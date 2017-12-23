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

#include <cstdio>

typedef long long ll;

ll calc_SIGMA2_mod(const ll MOD, const ll n)
{
    ll sq = 1;
    ll d = 3;
    ll r = 0;
    const ll lim = MOD < (n+1) ? MOD : (n+1);
    for (ll i=1; i < lim; ++i)
    {
        if (sq != 0)
        {
            ll j = i;
            ll jdiv = n / j;
            ll t = 0;
            while (jdiv > 1)
            {
                t = ((t + jdiv) % MOD);
                j += MOD;
                jdiv = n / j;
            }
            r = ((r + sq * (t + ((j <= n) ? ((1 + (n - j) / MOD) % MOD) : 0)))
                 % MOD);
        }
        sq = ((sq+d) % MOD);
        d += 2;
        if (i % 1000 == 0)
        {
            printf("Reached i=%lld ret=%lld\n", i, r);
#if 1
            fflush(stdout);
#endif
        }
    }
    return r;
}


int main()
{
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 1));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 2));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 3));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 4));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 5));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000, 6));
    printf("Result = %lld\n", calc_SIGMA2_mod(1000000000LL, 1000000000000000LL));

    return 0;
}
