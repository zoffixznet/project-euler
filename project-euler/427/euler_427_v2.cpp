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
#include <stdlib.h>
#include <string.h>
#include <string>
#include <queue>
#include <cassert>
#include <iostream>

typedef signed long long ll;

const ll MOD = 1000000009;

ll expmod(const ll b, const ll e)
{
    if (e == 0)
    {
        return 1;
    }
    const ll r = ((e & 1) ? b : 1);
    const auto rec = expmod(b, e >> 1);
    const auto rec_seq = rec * rec % MOD;
    return ((r * rec_seq) % MOD);
}

inline ll f(const ll n, const ll start, const ll end)
{
    const auto nm = n-1;
#if 0
    ll at_most[n+1] = {0};
    at_most[1] = (n * expmod(nm, nm)) % MOD;
    at_most[n] = expmod(n, n);
#endif

#if 0
    for (ll len_=n-1;len_>=2;--len_)
#endif
    for (ll len_=start;len_<=end;++len_)
    {
        ll s = n;
        if (((len_-1) << 1) > n)
        {
            const auto low_s = s * nm % MOD;
            s = s * expmod(n, len_) % MOD;
            s = (s - n) % MOD;
            const auto e = n-len_-1;
            if (e > 0)
            {
                s = (s * expmod(n, e) - low_s * e * expmod(n, e-1)) % MOD;
            }
        }
        else
        {
            std::queue<ll> state;
            state.push(n);
            for (ll pos=2;pos<=len_;++pos)
            {
                const auto t = s;
                s *= nm;
                state.push(s % MOD);
                s = ((s + t) % MOD);
            }
            for (ll pos=len_+1;pos<=n;++pos)
            {
                const auto t = s;
                s *= nm;
                state.push(s % MOD);
                s = ((s + t - state.front()) % MOD);
                state.pop();
            }
        }
#if 0
        at_most[len_] = s;
#endif
        std::cout << "p = " << len_ << "; ret = " << s << std::endl << std::flush;
    }
    ll ret = 0;
#if 0
    ll only[n+1] = {0};
    for (ll len_=1; len_<= n; ++len_)
    {
        only[len_] = at_most[len_] - at_most[len_-1];
        ret = ((ret + only[len_]*len_) % MOD);
    }
    assert(only[n] == n);
    assert(only[1] % MOD == at_most[1]);


    std::cout << "ret = " << ret << std::endl;
#endif

    return ret;
}

int main(int argc, char * argv[])
{
#if 0
    assert(f(3) == 45);
    assert(f(7) == 1403689);
    assert(f(11) == (481496895121LL % MOD));
#endif
    f(7500000, atol(argv[1]), atol(argv[2]));

#if 0
    std::cout << r << std::endl;
#endif

    return 0;
}
