#include <cstdio>

typedef long long ll;

ll k = 2;
const ll M = 1000000000 + 7;

class MyIter
{
    public:
        ll n, f, r;
        MyIter() : n(0), f(1), r(1) {};

    void inc()
    {
        if (++n < k)
        {
            f++;
        }
        else
        {
            auto & c = this[1];
            if (--r == 0)
            {
                r = k;
                c.inc();
            }
            if ((f += c.f) >= M)
            {
                f -= M;
            }
        }
    }
};

#if 1
const ll S = 1000000000LL;
#else
const ll S = 1000LL;
#endif

ll lim = S;
const ll w = 100000000000000LL;
int main()
{
    MyIter f[1000];

    auto & first = f[0];
    while (first.n < w)
    {
        while (first.n < lim)
        {
            first.inc();
        }
        printf ("f[%lld](%lld) = %lld\n", k, first.n, first.f);
        fflush(stdout);
        lim += S;
    }
    return 0;
}
