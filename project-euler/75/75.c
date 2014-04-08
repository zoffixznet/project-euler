#include <stdio.h>
#include <math.h>
#include <string.h>

#define limit 1500000

char verdicts[limit+1];

int main(int argc, char * argv[])
{
    int hypotenuse_lim = (limit / 2);

    memset(verdicts, '\0', sizeof(verdicts));

    for (int hypotenuse_length=5
            ;
         hypotenuse_length < hypotenuse_lim
            ;
         hypotenuse_length++
         )
    {
        if (hypotenuse_length % 1000 == 0)
        {
            printf("%d\n", hypotenuse_length);
        }

        long long hypot_sq = hypotenuse_length;

        hypot_sq *= hypot_sq;

        int side1_lim = (hypotenuse_length / 2);

        for(int side1_len = 1 ; side1_len < side1_lim ; side1_len++)
        {
            long long side1_sq = side1_len;

            side1_sq *= side1_sq;

            double side2_len = sqrt(hypot_sq - side1_sq);

            int side2_len_i = (int)side2_len;

            if (side2_len == side2_len_i)
            {
                int sum = side2_len_i + side1_len + hypotenuse_length;

                if (sum <= limit)
                {
                    if (verdicts[sum] != 2)
                    {
                        verdicts[sum]++;
                    }
                }
            }
        }
    }

    int count = 0;

    for (int sum = 12 ; sum < limit ; sum++)
    {
        if (verdicts[sum] == 1)
        {
            count++;
        }
    }

    printf("Count = %d\n", count);
    return 0;
}
