#include <stdio.h>

#include "bit_counts.h"

typedef long long ll;

typedef unsigned char byte;

const ll sqrt_limit = (1LL << 25);
const ll limit = (sqrt_limit * sqrt_limit);

const ll page_bits_size = (1LL << 32);
const ll page_bytes_size = (page_bits_size >> 3);

int main()
{
    printf ("%s\n", "Hello world!");
    return 0;
}
