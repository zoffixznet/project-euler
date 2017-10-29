#include <gmpxx.h>
#include <iostream>

const int BASE = 14;
const size_t MAX = 10000;

mpz_class MP[10030][BASE];

mpz_class ret = 0;

void rec(const size_t n, mpz_class sq, bool is_z, const size_t digits_sum)
{
    // print_('n =', n)
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
    auto m = MP[n];
    for (int d=0;d<BASE;++d)
    {
        rec(n+1, sq+m[d], (d == 0), digits_sum+d);
    }
}

int main()
{
    MP[0][0] = 0;
    MP[0][1] = 1;
        for (int d=2;d<BASE;++d)
        {
            MP[0][d] = d * MP[0][1];
        }
    for (int n=1;n<10030;++n)
    {
        for (int d=0;d<BASE;++d)
        {
            MP[n][d] = d * MP[n-1][1] * BASE;
        }
    }
    rec(0, 0, true, 0);
    std::cout << ret << std::endl;
}

#if 0
def rec(n, sq, is_z, digits_sum):
    # print_('sq =', sq)
    print_('n =', n)
    if n > MAX:
        return 0
    if (((sq*sq) % powers[n]) != sq):
        return 0
    if sq == 0 and n > 3:
        return 0
    ret = 0 if is_z else digits_sum
    m = MP[n]
    for d in xrange(0, BASE):
        ret += rec(n+1, sq+m[d], (d == 0), digits_sum+d)
    return ret

print_(rec(0, long(0), True, 0))
MAX = 10000
print_(rec(0, long(0), True, 0))
#endif
