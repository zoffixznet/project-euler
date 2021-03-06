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

#define NUM_DIGITS 10000
int num_digits = 1;
long long idx = 1;
int digits[NUM_DIGITS] = {0};

static inline void print_n()
{
    printf("a[%lld] = ", idx);
    for (int i = num_digits-1; i >= 0 ; i--)
    {
        printf("%d", digits[i]);
    }
    printf("\n");
    fflush(stdout);
}

int main()
{
    digits[0] = 1;

    const long long LIM = 1000000000000000;
    const long long STEP = 1000000000;
    long long checkpoint = STEP;

    for (;idx < LIM;idx++)
    {
        if (idx == checkpoint)
        {
            print_n();
            checkpoint += STEP;
        }
        long long sum = 0;
        for (int i = 0; i < num_digits; i++)
        {
            sum += digits[i];
        }
        int place = 0;
        while (sum > 0)
        {
            int d = sum % 10;
            int p = place;
            int diff = d;
            while ((digits[p] += diff) >= 10)
            {
                diff = digits[p] / 10;
                digits[p] %= 10;
                p++;
            }
            if (p >= num_digits)
            {
                num_digits = p+1;
            }
            sum /= 10;
            place++;
        }
    }

    print_n();

    return 0;
}
