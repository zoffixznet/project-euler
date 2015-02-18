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

