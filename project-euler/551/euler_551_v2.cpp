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

typedef unsigned long long ull;

const ull BASE = 10000;

ull lookup[BASE];

#define NUM_DIGITS 10000
ull digits = 1;
ull idx = 1;

static inline void print_n()
{
    printf("a[%lld] = %lld\n", idx, digits);
    fflush(stdout);
}

int main()
{
    // Initialize the lookup.
    for (int i = 0 ; i < BASE; i++)
    {
        int sum = 0;
        int ii = i;
        while (ii)
        {
            sum += ii % 10;
            ii /= 10;
        }
        lookup[i] = sum;
    }

#if 0
    const long long LIM = 1000000;
#else
    const long long LIM = 1000000000000000;
#endif
    const long long STEP = 1000000000;
    long long checkpoint = STEP;

    for (;idx < LIM;idx++)
    {
        if (idx == checkpoint)
        {
            print_n();
            checkpoint += STEP;
        }
        ull copy = digits;
        while (copy)
        {
            digits += lookup[ copy % BASE];
            copy /= BASE;
        }
    }

    print_n();

    return 0;
}
