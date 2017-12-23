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

#include <iostream>
#include <cmath>
#include <assert.h>

typedef unsigned long long ll;


inline ll isqrt(const ll n)
{
#if 1
    return sqrtl(n);
#else
    ll low = 0;
    ll high = n+1;
    while (high > low+1)
    {
        const unsigned __int128 mid = ((low + high) >> 1);
        if (mid*mid <= n)
        {
            low = mid;
        }
        else
        {
            high = mid;
        }
    }
    return low;
#endif
}

ll calc_R(const ll M, const ll N)
{
    const auto N2 = N*N;
    ll ret = 0;
    for (ll x=M+1;x <= N;++x)
    {
        const auto x2 = x*x;
        auto xs = x2;
        const auto x4 = x2 << 1;
        auto xn = xs + x2;
        while (xs <= N2)
        {
            auto s = isqrt(xs);
            if (s*s != xs)
            {
                ++s;
            }
            auto t = isqrt(xn);
            if (t*t == xn)
            {
                --t;
            }
            if (t > N)
            {
                t = N;
            }
            if (t >= s)
            {
                ret += t-s+1;
            }
            xs += x4;
            xn += x4;
        }
        if ((x & 1023) == 1023)
        {
            std::cout << "x = " << x << " ret = " << ret << std::endl << std::flush;
        }
    }
    return ret;
}


int main()
{
    const ll x1 = 1000000000;
    assert(isqrt(x1*x1) == x1);
    assert(calc_R(0, 100) == 3019);
    assert(calc_R(100, 10000) == 29750422);
    auto ret = calc_R(2000000, 1000000000);
    std::cout << "sol = " << ret << std::endl;

    return 0;
}
