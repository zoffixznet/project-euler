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

