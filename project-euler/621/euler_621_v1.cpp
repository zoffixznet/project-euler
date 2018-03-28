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
        if (tgt == s)
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

struct Result
{
    ll s, n, m;
    Result(const ll ss, const ll nn, const ll mm)
    {
        s = ss;
        n = nn;
        m = mm;
    }
};
typedef std::vector<MyIter2> MyVec;

class IterSumTwo
{
    public:
    MyIter2 it;
    MyVec * q;

    MyIter2 i()
    {
        return it.clone();
    }

    IterSumTwo() : it(0,0,0)
    {
        q = new MyVec;
        q->push_back(i());
    }

    Result next()
    {
        std::pop_heap(q->begin(), q->end(), greater1());
        auto iti = q->back();
        q->pop_back();
        const auto s = iti.s;
        const auto n = iti.n;
        if (n == it.n) {
            it.n_inc();
            q->push_back(i());
            std::push_heap(q->begin(), q->end(), greater1());
        }
        const auto m = iti.m;
        if (iti.adv())
        {
            q->push_back(iti);
            std::push_heap(q->begin(), q->end(), greater1());
        }
        return Result(s, n, m);
    }

    void skip(const ll tgt)
    {
        MyVec * new_ = new MyVec;
        ll maxn = 0;
        for (auto x: *q)
        {
            const auto n = x.n;
            if (x.skip(tgt)) {
                new_->push_back(x);
                if (maxn < n)
                    maxn = n;
            }
        }
        while (it.max < tgt)
            it.n_inc();
        while (it.s <= tgt)
        {
            if (maxn != it.n)
            {
                auto iti = i();
                iti.skip(tgt);
                new_->push_back(iti);
            }
            it.n_inc();
        }
        std::make_heap(new_->begin(), new_->end(), greater1());
        delete q;
        q = new_;
    }
};


// const ll PARTS = 10000;
const ll PARTS = 10;


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
        while (true)
        {
            Result snj = it.next();
            if (snj.s > tgt)
                break;
            snj.n *= snj.n+1;
            snj.m *= snj.m+1;
            const ll min_ = std::min(snj.n, std::min(snj.m, i));
            const ll max_ = std::max(snj.n, std::max(snj.m, i));
            printf(":: [%lld, %lld, %lld]\n", min_, snj.n+snj.m+i-min_-max_, max_);
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
my_find(1000000, std::stoll(argv[1]));
//my_find(17526 * 1000000000, int(sys.argv[1]))
return 0;
}
