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
#include <stdlib.h>
#include <algorithm>

typedef long long ll;

typedef u_int16_t u16;
typedef unsigned char byte;

const int start = 900-3*1;
const int end = 900-3*5000;

typedef double myfloat_t;

static inline myfloat_t s5000(const myfloat_t r)
{
    myfloat_t sum = 0;
    myfloat_t r_power = 1;
    for (int coeff = start; coeff >= end;coeff -= 3)
    {
        sum += (r_power * coeff);
        r_power *= r;
    }

    return sum;
}

const myfloat_t TARGET = -600000000000.0;

int main(int argc, char * argv[])
{
#if 0
    myfloat_t r = atof(argv[1]);

    printf("s5000(%f) = %f\n", r, s5000(r));
#endif

    myfloat_t low = 1.0;
    myfloat_t high = 1.005;
    myfloat_t mid = ((low+high)/2);
    myfloat_t mid_val = s5000(mid);
    while (1)
    {
        printf("s5000(%.30f) = %.30f\n", mid, mid_val);
        fflush(stdout);
        if (mid_val > TARGET)
        {
            low = mid;
        }
        else
        {
            high = mid;
        }
        mid = ((low+high)/2);
        mid_val = s5000(mid);
    }
    return 0;
}
