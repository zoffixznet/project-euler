#include <stdio.h>

#define NUM_DIGITS 10000
int num_digits = 1;
int digits[NUM_DIGITS] = {0};

static inline void print_n()
{
    for (int i = num_digits-1; i >= 0 ; i--)
    {
        printf("%d", digits[i]);
    }
}

int main()
{
    digits[0] = 1;
    long long idx = 1;

    const long long LIM = 1000000;
    const long long STEP = 1000000;

    for (;idx < LIM;idx++)
    {
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

    printf("a[%lld] = ", idx);
    print_n();
    printf("\n");

    return 0;
}
