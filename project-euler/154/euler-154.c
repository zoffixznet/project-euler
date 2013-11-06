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
            for (int i = power; i <= LIM ; i += power)
            {
                c5_counts[i]++;
            }
            base++;
            power *= BASE;
        }
    }

    long result = 0;
    int x_count = 0;

    /* At the beginning of the x loop, x_count is the 5-cardinality
     * of (200,000! / [ (x!) * (y=0) * (z = 200,000-x) ]
     *
     * */
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
            if (y_count >= 12)
            {
                result++;
            }
#if 0
            printf("y_count=%d\n", y_count);
#endif
            y_count += c5_counts[LIM_min_x-y-1]-c5_counts[y+1];
        }

        /*
         * As x -> x+1
         *
         * */
        x_count += c5_counts[LIM_min_x-1]-c5_counts[x+1];
    }

    printf ("Result == %ld\n", result);
}
