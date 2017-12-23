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

char Cache[315730];


int num_distinct_factors(int n, int start_from)
{
    if (n == 1)
    {
        return 0;
    }

    if (Cache[n] == 0)
    {
        int ret;
        int d = n;

        while (d % start_from)
        {
            start_from++;
        }
        while (d % start_from == 0)
        {
            d /= start_from;
        }
        ret = num_distinct_factors(d, start_from);
        Cache[n] = ((ret == 5) ? 5 : (ret+1));
    }

    return Cache[n];
}

int main()
{
    int check, n, found;

    memset(Cache, '\0', sizeof(Cache));

    for (check=100 ; check < 315720 ; check++)
    {
        found = 1;
        for (n = check ; n < check + 4 ; n++)
        {
            if (num_distinct_factors(n, 2) != 4)
            {
                found = 0;
                break;
            }
        }
        if (found)
        {
            printf("Found %d\n", check);
            break;
        }
    }

    return 0;
}

