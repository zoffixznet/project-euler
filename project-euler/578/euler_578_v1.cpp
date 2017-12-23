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
        for (;;p += 2)
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
                break;
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
#if 0
        else
        {
            std::cout << i << std::endl;
        }
#endif
        if (i == checkpoint)
        {
            std::cout << "C(" << i << ") = " << count << std::endl;
            checkpoint += STEP;
        }
    }
    std::cout << "C(" << end << ") = " << count << std::endl;
    return 0;
}
