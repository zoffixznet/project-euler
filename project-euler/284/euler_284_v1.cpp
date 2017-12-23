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
