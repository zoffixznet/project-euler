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

#define LIM 200000

#define BASE 5
#define BASE2 2

signed char c5_counts[LIM+1];
signed char c2_counts[LIM+1];

int main()
{
    /* Initialize c5_counts. */
    {
        memset(c5_counts, '\0', sizeof(c5_counts));
        int base = 1;
        int power = BASE;
        while (power <= LIM)
        {
            for (int i = power; i <= LIM ; i += power)
            {
                c5_counts[i]++;
            }
            base++;
            power *= BASE;
        }
    }
    {
        memset(c2_counts, '\0', sizeof(c2_counts));
        int base = 1;
        int power = BASE2;
        while (power <= LIM)
        {
            for (int i = power; i <= LIM ; i += power)
            {
                c2_counts[i]++;
            }
            base++;
            power *= BASE2;
        }
    }

    long result = 0;
    int x_count = 0;
    int x_count2 = 0;

    /* At the beginning of the x loop, x_count is the 5-cardinality
     * of (200,000! / [ (x!) * (y=0)! * (z = 200,000-y-x)! ]
     *
     * */
    for(int x = 0; x <= LIM; x++)
    {
        if (x % 1000 == 0)
        {
            printf("X=%d\n", x);
        }
        int y_count = x_count;
        int y_count2 = x_count2;
        const int LIM_min_x = LIM - x;
        for (int y = 0; y <= LIM_min_x; y++)
        {
            if ((y_count >= 12) && (y_count2 >= 12))
            {
                result++;
            }
            y_count += c5_counts[LIM_min_x-y]-c5_counts[y+1];
            y_count2 += c2_counts[LIM_min_x-y]-c2_counts[y+1];
        }

        /*
         * As x -> x+1
         *
         * */
        x_count += c5_counts[LIM_min_x]-c5_counts[x+1];
        x_count2 += c2_counts[LIM_min_x]-c2_counts[x+1];
    }

    printf ("Result == %ld\n", result);
}
