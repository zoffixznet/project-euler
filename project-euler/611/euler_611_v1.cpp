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

ll solve_for(const ll n)
{
    ll sq = 1;
    ll d2 = 5;
    ll sq2 = 4;
    std::priority_queue<p, std::vector<p>, std::greater<p>> pq;
    ll sum_sq = sq + sq2;
    while (sum_sq <= n)
    {
        pq.push(p(sum_sq, d2));
        sq = sq2;
        sq2 += d2;
        sum_sq = sq + sq2;
        d2 += 2;
    }
    ll ret = 0;
    ll last = -1;
    bool count = false;
    while (!pq.empty())
    {
        const auto pa = pq.top();
        pq.pop();
        const auto this_ = pa.first;
        const auto d = pa.second;
        if (this_ != last)
        {
            if (count)
            {
                if (((++ret) & 0x3FFFF) == 0)
                {
                    std::cout << "Reached " << this_ << " d = " << d << " ret = " << ret << std::endl << std::flush;
                }
            }
            count = false;
            last = this_;
        }
        count = !count;
        const auto new_ = this_+d;
        if (new_ <= n)
        {
            pq.push(p(new_, d+2));
        }
    }
    if (count)
    {
        ++ret;
    }
    return ret;
}

void pr(const ll n)
{
    std::cout << "F(" << n << ") = " << solve_for(n) << std::endl;
}

int main()
{
    pr(5);
    pr(100);
    pr(1000);
    pr(1000000);
    pr(1000000000000LL);
    return 0;
}
