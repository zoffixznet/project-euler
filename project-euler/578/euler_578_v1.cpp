#include <iostream>
#include <cstdlib>
#include <cmath>

typedef long long ll;

bool is_right(ll n)
{
    int last = 0;

    while ((n & 0x1) == 0)
    {
        last++;
        n >>= 1;
    }
    ll p = 3;
    while (n > 1)
    {
        const ll root = (ll)sqrtl(n);
        for (;;p++)
        {
            if (p > root)
            {
                return true;
            }
            int current = 0;
            while (n % p == 0)
            {
                if ((++current) > last && last > 0)
                {
                    return false;
                }
                n /= p;
            }
            if (current > 0)
            {
                last = current;
            }
        }
    }
    return true;
}

int main(int argc, char * argv[])
{
    const ll proto_start = atoll(argv[1]);
    const ll end = atoll(argv[2]);

    ll count = 0;
    ll start = proto_start;
    if (start == 1)
    {
        count++;
        start++;
    }

    const ll STEP = 1000000;
    ll checkpoint = start + STEP;
    checkpoint += (STEP - (checkpoint % STEP));

    for (auto i = start; i <= end ; i++)
    {
        if (is_right(i))
        {
            count++;
        }
        if (i == checkpoint)
        {
            std::cout << "C(" << i << ") = " << count << std::endl;
            checkpoint += STEP;
        }
    }
    std::cout << "C(" << end << ") = " << count << std::endl;
    return 0;
}
