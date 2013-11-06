#include <stdio.h>
#include <string.h>

#define LIM 200000

#define BASE 5

unsigned char c5_counts[LIM+1];

int main()
{
    /* Initialize c5_counts. */
    {
        memset(c5_counts, '\0', sizeof(c5_counts));
        int base = 1;
        int power = BASE;
        while (power <= LIM)
        {
            for(int i = power; i <= LIM ; i += power)
            {
                c5_counts[i]++;
            }
            base++;
            power *= BASE;
        }
    }

    long result = 0;
    int x_count = 0;

    for(int x = 0; x <= LIM; x++)
    {
        if (x % 1000 == 0)
        {
            printf("X=%d\n", x);
        }
        int y_count = x_count;
        const int LIM_min_x = LIM - x;
        for (int y = 0; y <= LIM_min_x; y++)
        {
            if ((y_count += c5_counts[LIM_min_x-y]-c5_counts[y]) >= 12)
            {
                result++;
            }
            printf("y_count=%d\n", y_count);
        }

        x_count += c5_counts[LIM_min_x-1]-c5_counts[x+1];
    }

    printf ("Result == %ld\n", result);
}
