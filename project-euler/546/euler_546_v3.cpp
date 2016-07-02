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
            if (f += c.f >= M)
            {
                f -= M;
            }
        }
    }
};

const ll S = 1000000000LL;
ll lim = S;
const ll w = 100000000000000LL;
int main()
{
    MyIter * f = new MyIter[1000];

    while (f->n < w)
    {
        while (f->n < lim)
        {
            f->inc();
        }
        printf ("f[%lld](%lld) = %lld\n", k, f->n, f->f);
        fflush(stdout);
        lim += S;
    }

    delete f;

    return 0;
}
