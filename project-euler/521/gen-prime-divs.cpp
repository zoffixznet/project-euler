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

typedef unsigned __int128 ll;

std::string ll2s_(const ll n)
{
    char s[2] = {0,0};
    if (n == 0)
    {
        return std::string("");
    }
    s[0] = '0' + n % 10;
    return ll2s_(n / 10) + std::string(s);
}

std::string ll2s(const ll n)
{
    if (n == 0)
    {
        return std::string("0");
    }
    return ll2s_(n);
}
const ll MAX = 1000000000000LL;

int main()
{
    char cmd[100];
    snprintf(cmd, sizeof(cmd), "primesieve -p 1000160 1000000000000");

    FILE * f = popen(cmd, "r");

    ll c = 0, s = 0, d = 1000000;
    ll inv = MAX / d;
    const ll MIN_d = 28;

    while (true)
    {
        unsigned long long p;
        fscanf(f, "%llu", &p);
        while (p > inv)
        {
            printf("d = %d count = %s sum = %s\n", (int)d, ll2s(c).c_str(), ll2s(s).c_str());
            fflush(stdout);
            if (--d == MIN_d)
            {
                pclose(f);
                return 0;
            }
            inv = MAX / d;
        }
        ++c;
        s += p;
    }
    return -1;
}
