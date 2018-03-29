/*

# The Expat License
#
# Copyright (c) 2018, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

*/

#include <cmath>
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <vector>

typedef long long ll;

class MyIter2
{
    public:

    ll init_s, n, s, m, max;

    MyIter2(const ll nn, const ll ss, const ll mm)
    {
        n = nn;
        s = init_s = ss;
        m = mm;
        max = s + ((n*(n+1)-m*(m+1)));
    }

    bool skip(const ll tgt)
    {
        if (tgt > max)
            return false;
        if (s >= tgt)
            return true;
        m = floor(sqrt(tgt-init_s));
        s = init_s + ((m*(m+1)));
        if (s < tgt)
        {
            s += ((++m) << 1);
        }
        return true;
    }

    bool adv()
    {
        if (m == n)
            return false;
        s += ((++m) << 1);
        return true;
    }

    void n_inc()
    {
        init_s = (s += ((++n) << 1));
        max += (n << 2);
    }

    MyIter2 clone() const
    {
        return MyIter2(n, s, m);
    }
};

struct greater1{
    bool operator()(const MyIter2 & a,const MyIter2 & b) const {
        if (a.s == b.s)
            return a.n > b.n;
        return a.s > b.s;
    }
};

typedef std::vector<MyIter2> MyVec;

class IterSumTwo
{
    public:
    MyIter2 it;
    MyVec q, to_flush;

    MyIter2 i()
    {
        return it.clone();
    }

    IterSumTwo() : it(0,0,0), q(), to_flush()
    {
        q.push_back(i());
    }

    ll maxn;

    void examine(const ll tgt, MyIter2 x, MyVec & new_, MyVec & new_f)
    {
        const auto n = x.n;
        if (x.skip(tgt)) {
            (x.s == tgt ? new_f : new_).push_back(x);
            if (maxn < n)
                maxn = n;
        }
    }

    void skip(const ll tgt)
    {
        MyVec new_, new_f;
        maxn = 0;
        for (auto x: q)
        {
            examine(tgt, x, new_, new_f);
        }
        for (auto x: to_flush)
        {
            examine(tgt, x, new_, new_f);
        }
        while (it.max < tgt)
            it.n_inc();
        const ll mymax = maxn;
        while (it.s <= tgt)
        {
            if (mymax != it.n)
            {
                examine(tgt, i(), new_, new_f);
            }
            it.n_inc();
        }
        q = new_;
        to_flush = new_f;
    }
};

#define PROD

#ifdef PROD
const ll PARTS = 10000;
#else
const ll PARTS = 10;
#endif

void my_find(const ll preM, const ll part)
{
    const ll M = preM << 1;
    ll m = floor(sqrt(M));
    const ll high_m = std::min(m * (part+1) / PARTS - 1, m);
    const ll low_m = m * part / PARTS;
    m = high_m;
    ll i = ((m * (m+1)));
    ll tgt = M-i;
    IterSumTwo it;
    printf("== Solving %lld->%lld | %lld / %lld\n", low_m, high_m, part, PARTS);
    while (m >= low_m)
    {
        fprintf(stderr, "i = %lld %lld %lld %lld\n", i, m, low_m, tgt);
        it.skip(tgt);
        for (auto iti: it.to_flush)
        {
            auto n = iti.n;
            auto j = iti.m;
            n *= n+1;
            j *= j+1;
            const ll min_ = std::min(n, std::min(j, i));
            const ll max_ = std::max(n, std::max(j, i));
            printf(":: [%lld, %lld, %lld]\n", min_, n+j+i-min_-max_, max_);
        }
        i -= (m << 1);
        tgt += (m << 1);
        --m;
    }
    printf("== Finished %lld->%lld | %lld / %lld\n", low_m, high_m, part, PARTS);
}


int main(int, char * argv[])
{
// my_find(1000)
#ifdef PROD
    my_find(17526LL * 1000000000LL, std::stoll(argv[1]));
#else
    my_find(1000000, std::stoll(argv[1]));
#endif
    return 0;
}
