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
#include <set>
#include <map>
#include <cstdio>
#include <cmath>
#include <cstdlib>
#include <algorithm>

typedef long long LL;

std::set<LL> squares;
/*
my %squares = (map { _ * _ => undef() } 1 .. 999_999);
# my sum = 0;
*/

int d;
LL d3;
// std::map<int,int> * factors;
std::map<int,int>::iterator factors_end;

void divisors(LL r, const std::map<int,int>::iterator this_)
{
    if (this_ == factors_end)
    {
        /* Handle the stuff. */
        LL n = (r + d3 / r);

        if (squares.find(n) != squares.end())
        {
            if (n % d == r)
            {
                LL i[3] = {n/d,d,r};
                std::sort(std::begin(i), std::end(i));
                if (i[1] * i[1] == i[0] * i[2])
                {
                    printf( "Found for d=%d r=%lld q=%lld n=%lld\n",
                        d, r, n/d, n
                    );
                    fflush(stdout);
                }
            }
        }
    }
    else
    {
        std::map<int,int>::iterator rest(this_);
        rest++;

        int b = (*this_).first;
        int e = (*this_).second;

        for (int i = 0 ; i <= e ; i++)
        {
            if (r >= d)
            {
                break;
            }
            divisors(r, rest);
            r *= b;
        }
    }
}

int main()
{
    for (LL i = 0 ; i <= 999999 ; i++)
    {
        squares.insert(i*i);
    }

    FILE * f = fopen("factors.txt", "rt");
    for (d = 2; d < 1000000 ; d++)
    {
        if (d % 1000 == 0)
        {
            printf( "D=%d\n", d);
            fflush(stdout);
        }
        d3 = ((LL)d) * d * d;

        std::map<int,int> physical_factors;
        int factor;
        while (fscanf(f, "%d", &factor) == 1)
        {
            if (factor == -1)
            {
                break;
            }
            physical_factors[factor] += 3;
        }

        factors_end = physical_factors.end();
        divisors(1, physical_factors.begin());
    }
    fclose (f);

    return 0;
}

