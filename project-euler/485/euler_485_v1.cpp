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
#include <map>
#include <set>
#include <string>
#include <sstream>
#include <string.h>
#include <stdio.h>
#include <queue>

typedef long long ll;
ll THRESHOLD;
#define DS DISPLAY_STEP
#define TH THRESHOLD

struct Rec
{
    ll n, v;
    Rec(ll new_n, ll new_v) { n = new_n; v = new_v; }
};

struct Rec_cmp
{
    bool operator()(const Rec * A, const Rec * B) const
    {
        if (A->v < B->v)
        {
            return true;
        }
        if (A->v == B->v && A->n < B->n)
        {
            return true;
        }
        return false;
    }
};

FILE * fh;

std::set<Rec *, Rec_cmp> T;

std::queue<Rec *> Q;

static inline void add(void)
{
    char l[4000];

    fgets(l, sizeof(l), fh);
    l[sizeof(l)-1] = '\0';

    std::map <ll, ll> f;
    std::stringstream ls(l);

    ll n;
    char c;
    // c is the ':'
    ls >> n >> c;
    ll val = 1;

    ll i;

    while (ls >> i)
    {
        ++f[i];
    }
    for (const auto x: f)
    {
        val *= (1 + x.second);
    }

    if (val >= TH)
    {
        Rec * const rec = new Rec(n, val);
        Q.push(rec);
        T.insert(rec);
    }

    return;
}

template <typename T>
inline const typename T::key_type& last_key(const T& pMap)
{
    return *(pMap.rbegin());
}

ll sum = 0;

static inline void update(void)
{
    sum += last_key(T)->v;

    return;
}

int main(int argc, char * argv[])
{
    int arg = 1;

    const ll MAX = std::stoll(argv[arg++]);
    const ll STEP = std::stoll(argv[arg++]);
    const ll DISPLAY_STEP = std::stoll(argv[arg++]);
    THRESHOLD = std::stoll(argv[arg++]);

    char buf[4000];
    sprintf(buf, "seq 1 '%lld' | xargs factor", MAX+1);
    fh = popen(buf, "r");


    for (ll i = 1 ; i <= STEP; ++i)
    {
        add();
    }

    update();
    for (ll n = STEP+1, l = 1 ; n <= MAX; ++n, ++l)
    {
        while (!Q.empty() && Q.front()->n <= l)
        {
            auto r = Q.front();
            Q.pop();
            T.erase(r);
            delete r;
        }
        add();
        update();
        if (n % DS == 0)
        {
            std::cout << "Reached " << n << " : Sum = " << sum << std::endl;
        }
    }
    std::cout << "Final Sum = " << sum << std::endl;

    pclose(fh);

    return 0;
}
