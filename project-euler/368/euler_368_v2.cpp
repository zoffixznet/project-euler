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

#include <stdio.h>
#include <string.h>
#include <string>

#if 0
typedef unsigned __int128 ll;
#else
typedef unsigned long ll;
#endif

std::string ll2s(const ll n)
{
    char s[2] = {0,0};
    if (n == 0)
    {
        return std::string("");
    }
    s[0] = '0' + n % 10;
    return ll2s(n / 10) + std::string(s);
}

ll str2ll(const char * s, const ll ret)
{
    if (*s == 0)
    {
        return ret;
    }
    return str2ll(s+1, ret*10+(s[0]-'0'));
}

ll P[1000];
ll s = 0;

void it(const ll *const p, ll n, const bool c, const size_t last)
{
    if (p < P)
    {
#if 0
        s += ((10000000000000000 * (ll)100000000000000) / n);
#else
        s += ((10000000000000000LL) / n);
#endif
        return;
    }
    const auto r = p - 1;
    const auto D = *p;
    for (size_t d = 0; d < last; ++d)
    {
        it(r, n, true, d);
        n += D;
    }
    if (c)
    {
        it(r, n, false, last);
    }
    n += D;
    for (size_t d = last+1; d < 10; ++d)
    {
        it(r, n, true, d);
        n += D;
    }
}

int main()
{
    P[0] = 1;
    for (int i = 0; i < 999; i++)
    {
        P[i+1] = 10 * P[i];
    }

    size_t L = 1;
    while (true)
    {
        for (size_t d = 1; d < 10; ++d)
        {
            it(&P[L-2], d*P[L-1], true, d);
            printf("n=%zd t = %s\n", L, ll2s(s).c_str());
            fflush(stdout);
        }
        L += 1;
    }

    return 0;
}
