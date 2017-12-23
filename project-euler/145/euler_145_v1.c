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

/*
 * =====================================================================================
 *
 *       Filename:  euler145.c
 *
 *    Description: Solution to Project Euler #145
 *
 *    By: Shlomi Fish ( http://www.shlomifish.org/ ).
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{
    int limit;
    int n;

    int count = 0;

    limit = atoi(argv[1]);

    for (n = 21 ; n < limit ; )
    {

        if (n % 1000000 == 1)
        {
            printf ("Reached %i\n", n);
        }
        int reverse = 0;
        int temp_n = n;

        int power_of_ten = 1;
        while (temp_n)
        {
            reverse = reverse * 10 + (temp_n % 10);
            if (temp_n /= 10)
            {
                power_of_ten *= 10;
            }
        }

        /*
         * If leading digit is odd, then the last digit of the sum
         * for all the numbers will be even. So we should skip this
         * range.
         * */
        if (reverse & 0x1)
        {
            n += power_of_ten;
            continue;
        }

        int sum = n + reverse;

        while (sum & 0x1)
        {
            sum /= 10;
        }

        if (sum == 0)
        {
            count += 2;
        }

        n += 2;
    }

    printf("Count = %i\n", count);

    return 0;
}
