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
#include <math.h>
#include <stdlib.h>

typedef long long LL;

int comp (const void * v_a, const void * v_b)
{
    LL a = *(LL*)v_a;
    LL b = *(LL*)v_b;
    return ((a < b) ? -1 : (a > b) ? 1 : 0);
}

int main()
{
    LL sum = 0;

    for (int n_root = 1; n_root < 1000000; n_root++)
    {
        LL n = (((LL)n_root) * n_root);

        for (LL r=1;r<n;r++)
        {
            LL prod = r * (n-r);
            double d_guess = pow(prod, (1.0/3));

            if (d_guess <= r)
            {
                break;
            }

            LL d = -1;
            for (LL d_guess_i = (LL)d_guess-1; d_guess_i <= (LL)d_guess+1;d_guess_i++)
            {
                if (d_guess_i * d_guess_i * d_guess_i == prod)
                {
                    d = d_guess_i;
                    break;
                }
            }
            if (d >= 0)
            {
                if (n%d == r)
                {
                    LL seq[3];
                    seq[0] = r;
                    seq[1] = d;
                    seq[2] = n / d;

                    qsort(seq, sizeof(seq)/sizeof(seq[0]), sizeof(seq[0]), comp);
                    if (seq[1] * seq[1] == seq[0] * seq[2])
                    {
                        sum += n;
                        printf("Found Intermediate sum[n=%lld] = %lld\n", n, sum);
                        fflush(stdout);
                        break;
                    }
                }
            }
        }
        printf ("Intermediate sum[n_root=%d] = %lld\n", n_root, sum);
        fflush(stdout);
    }
    printf ("Final sum = %lld\n", sum);
    fflush(stdout);
}

