#include <gmpxx.h>
#include <iostream>

const size_t BASE = 14;
const size_t MAX = 10000;

mpz_class MP[10030][BASE];

mpz_class ret = 0;

static void rec(const size_t n, const mpz_class sq, const bool is_z, const size_t digits_sum)
{
    if (n > MAX)
    {
        return;
    }
    if (((sq*sq) % MP[n][1]) != sq)
    {
        return;
    }
    if (sq == 0 and n > 3)
    {
        return;
    }
    if (! is_z)
    {
        ret += digits_sum;
    }
    const auto m = MP[n];
    for (size_t d=0;d<BASE;++d)
    {
        rec(n+1, sq+m[d], (d == 0), digits_sum+d);
    }
}

int main()
{
    for (size_t d=0;d<BASE;++d)
    {
        MP[0][d] = d;
    }
    for (size_t n=1;n<10030;++n)
    {
        for (size_t d=0;d<BASE;++d)
        {
            MP[n][d] = d * MP[n-1][1] * BASE;
        }
    }
    rec(0, 0, true, 0);
    std::cout << ret << std::endl;
}
