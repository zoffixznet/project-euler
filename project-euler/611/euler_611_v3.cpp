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

#include <functional>
#include <queue>
#include <vector>
#include <iostream>
#include <utility>

typedef unsigned long long ll;
typedef std::pair<ll, ll> p;

const ll bit_shift = 4;
const ll bits_per_unit = (1 << bit_shift);
const ll bit_mask = bits_per_unit - 1;
typedef unsigned short u;
const ll num_opts = 1 << bits_per_unit;
ll count_bits[num_opts];

const ll lim = 10000000LL;
const ll ulim = lim >> bit_shift;
u bits[ulim];

ll solve_for(const ll n)
{
    ll sq = 1;
    ll d2 = 5;
    ll sq2 = 4;
    ll sum_sq = sq + sq2;
    ll c = 0;
    while (sum_sq <= n)
    {
        c++;
        sq = sq2;
        sq2 += d2;
        sum_sq = sq + sq2;
        d2 += 2;
    }
    p * pq = new p[c];
    sq = 1;
    d2 = 5;
    sq2 = 4;
    sum_sq = sq + sq2;
    c = 0;
    while (sum_sq <= n)
    {
        pq[c++] = p(sum_sq, d2-2);
        sq = sq2;
        sq2 += d2;
        sum_sq = sq + sq2;
        d2 += 2;
    }

    ll ret = 0;
    ll start = 0;
    ll lim1 = std::min(start+lim, n+1);
    while (start < n)
    {
        for (ll i=0;i<ulim;i++)
        {
            bits[i] = 0;
        }
        for (ll i=0;i<c;)
        {
            while (pq[i].first < lim1)
            {
                const auto delta = pq[i].first - start;
                bits[delta >> bit_shift] ^= (1 << (delta & bit_mask));
                if ((pq[i].first += (pq[i].second += 2)) > n)
                {
                    pq[i--] = pq[--c];
                    break;
                }
            }
            ++i;
        }
        for (ll i=0;i<ulim;i++)
        {
            ret += count_bits[bits[i]];
        }
        std::cout << "Reached " << lim1 << " ret = " << ret << std::endl << std::flush;
        start += lim;
        lim1 = std::min(start+lim, n+1);
    }
    delete [] pq;
    return ret;
}

void pr(const ll n)
{
    const auto res = solve_for(n);
    std::cout << "F(" << n << ") = " << res << std::endl;
}

int main()
{
    for (ll i=0;i<num_opts;i++)
    {
        ll c = 0;
        ll j = i;
        while (j)
        {
            c += (j&1);
            j >>= 1;
        }
        count_bits[i] = c;
    }
    pr(5);
    pr(100);
    pr(1000);
    pr(1000000);
    pr(1000000000000LL);
    return 0;
}
