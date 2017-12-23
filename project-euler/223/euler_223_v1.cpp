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
#include <assert.h>
#include <string.h>
#include <math.h>

typedef long long ll;

typedef unsigned char byte;

const ll LIM = 25000000;

int main()
{
    // For the case where A = 1.
    ll count = (int)sqrt((LIM-1)/2);
    ll As = 4;
    ll Ad = 3;
    ll l = LIM/3;
    for (ll A=2; A <= l; A++, As += (Ad += 2))
    {
        printf("Checking A=%lld\n", A);
        ll Cs = ((As<<1)-1);
        ll Bd = Ad;
        for (ll B=A; B <= l ; B++, Cs += (Bd += 2))
        {
            ll C = (ll)(sqrt(Cs));
            if (A+B+C > LIM)
            {
                break;
            }
            if (C*C == Cs)
            {
                printf ("Found (%lld,%lld,%lld) %lld\n",
                    A, B, C, ++count
                );
            }
        }
    }
    printf ("Final count=%lld\n", count);

    return 0;
}
