#include <set>
#include <array>
#include <cstdio>
#include <set>

typedef long long ll;

int main()
{
    std::array<ll, 15> primes{ {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47} };
    std::set<ll> t;
    for (auto x: primes)
    {
        t.insert(x);
    }
    ll prev = 1;
    ll s = 0;
    while (true)
    {
        auto n = *(t.begin());
        t.erase(n);
        if (n == prev + 1)
        {
            s += prev;
            printf("Found s = %lld for n = %lld\n", s, prev);
            fflush(stdout);
        }
        for (auto x: primes)
        {
            t.insert(x * n);
        }
        prev = n;
    }

    return 0;
}
