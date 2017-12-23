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

typedef long long ll;

const ll STEP = 1000;

static inline const ll calc(const ll n)
{
    for (ll x=n-1;x>1;x--)
    {
        if (((x*x) % n) == x)
        {
            return x;
        }
    }
    return 1;
}

int main(int argc, char * argv[])
{
    ll sum = 0;

    ll print_at = STEP;

    for (ll n=2;n<=10000000;n++)
    {
        sum += calc(n);
        if (n == print_at)
        {
            printf ("N=%lld Sum = %lld\n", n, sum);
            fflush(stdout);
            print_at += STEP;
        }
    }

    printf ("Final sum = %lld\n", sum);
    return 0;
}
