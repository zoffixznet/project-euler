#include <stdio.h>

typedef long long LL;

int main()
{
    int count = 0;

    const LL lim = 1 << 30;
    for (LL n = 1; n <= lim ; n++)
    {
        if ((n ^ (n<<1) ^ (n*3)) == 0)
        {
            count++;
        }
    }

    printf ("Result = %d\n", count);
    return 0;
}
