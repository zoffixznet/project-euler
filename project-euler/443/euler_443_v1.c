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
#include <stdint.h>
#include <stdlib.h>

typedef unsigned long long ll;

static inline ll gcd(ll n, ll m)
{
    while (m > 0)
    {
        const ll new_m = n%m;
        n = m;
        m = new_m;
    }
    return n;
}

int main(int argc, char * argv[])
{
    const ll TARGET = atoll(argv[1]);
    ll g = 13;
    for (ll n = 5 ; n <= TARGET ; n++)
    {
        g += gcd(g, n);
#if 0
        if ((n & ((1 << 20)-1)) == 0)
#else
        if (1)
#endif
        {
            printf ("g[%lld] = %lld\n", (long long)n, (long long)g);
        }
    }
    printf ("g[%lld] = %lld\n", (long long)TARGET, (long long)g);

    return 0;
}
