#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <algorithm>

typedef long long ll;

typedef u_int16_t u16;
typedef unsigned char byte;

const int start = 900-3*1;
const int end = 900-3*5000;

typedef double myfloat_t;

static inline myfloat_t s5000(const myfloat_t r)
{
    myfloat_t sum = 0;
    myfloat_t r_power = 1;
    for (int coeff = start; coeff >= end;coeff -= 3)
    {
        sum += (r_power * coeff);
        r_power *= r;
    }

    return sum;
}

const myfloat_t TARGET = -600000000000.0;

int main(int argc, char * argv[])
{
#if 0
    myfloat_t r = atof(argv[1]);

    printf("s5000(%f) = %f\n", r, s5000(r));
#endif

    myfloat_t low = 1.0;
    myfloat_t high = 1.005;
    myfloat_t mid = ((low+high)/2);
    myfloat_t mid_val = s5000(mid);
    while (1)
    {
        printf("s5000(%.30f) = %.30f\n", mid, mid_val);
        fflush(stdout);
        if (mid_val > TARGET)
        {
            low = mid;
        }
        else
        {
            high = mid;
        }
        mid = ((low+high)/2);
        mid_val = s5000(mid);
    }
    return 0;
}
