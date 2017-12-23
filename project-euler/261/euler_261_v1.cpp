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

#include <array>
#include <set>
#include <cstdio>

typedef unsigned __int128 ll;

const ll LIM = 10000000000;

void find_pivots(const ll m)
{
    ll s_k = 0;
    ll k = m+1;
    ll k_m = 1;
    for (ll i = k_m; i <= k; i++)
    {
        s_k += i*i;
    }
    ll n = m;
    ll n_m = 1;
    ll s_n = 0;
    for (ll i = n_m; i <= n; i++)
    {
        s_n += i*i;
    }
    while (k <= LIM)
    {
        if (k % 10000000 == 0)
        {
            printf("Reached %lld\n", (long long)k);
        }
        while (s_n < s_k)
        {
            ++n;
            ++n_m;
            s_n += n*n-n_m*n_m;
        }
        if ((s_n == s_k) && (n > k))
        {
            printf("Found %lld\n", (long long)k);
        }
        ++k;
        ++k_m;
        s_k += k*k-k_m*k_m;
    }
}

int main()
{
    find_pivots(2);
    return 0;
}
