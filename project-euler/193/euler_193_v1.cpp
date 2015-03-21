#include <stdio.h>
#include <assert.h>
#include <string.h>

#include "bit_counts.h"

typedef long long ll;

typedef unsigned char byte;

const ll sqrt_limit = (1LL << 25);
const ll limit = (sqrt_limit * sqrt_limit);

const ll page_bits_size = (1LL << 32);
const ll page_bytes_size = (page_bits_size >> 3);

static byte buffer[page_bytes_size];

const int NUM_PRIMES = 2063688;

ll primes_squares[NUM_PRIMES];

int main()
{
    char cmd[1000];
    printf ("%s\n", "Reading primes.");
    snprintf(cmd, sizeof(cmd), "primes 3 %lld", sqrt_limit);
    FILE * f = popen(cmd, "r");
    ll * p_ptr = primes_squares;
    ll p;
    while (fscanf(f, "%lld", &p) == 1)
    {
        *(p_ptr++) = p*p;
    }
    const ll * p_end = primes_squares+NUM_PRIMES;

    assert(p_ptr == p_end);
    printf ("%s\n", "Finished reading primes.");

    ll start = 1;
    ll end = start + page_bits_size - 1;


    while (end <= limit)
    {
        printf("Checking %lld - to %lld\n" , start, end);
        fflush(stdout);
        // Mark the products of 2*2 as non-squarefree and the rest as
        // potentially squarefree.
        memset (buffer, ((1 << 3) | (1 << (3 + 4))), sizeof(buffer));

        const ll offset_end = end-start;

        for (p_ptr = primes_squares;p_ptr < p_end; p_ptr++)
        {
            const ll step = (*p_ptr);

            if (step > end)
            {
                break;
            }
            ll i = start;

            const ll mod = i % step;
            if (mod)
            {
                i += (step - mod);
            }

            for (i -= start; i <= offset_end; i+= step)
            {
                buffer[i >> 3] |= (1 << (i & 0x7));
            }
        }

        ll count = 0;
        /* Count the numbers */
        for (long i=0;i < page_bytes_size; i++)
        {
            count += zero_bitcounts[buffer[i]];
        }

        printf ("Result for %lld - to %lld == %lld\n", start, end, count);
        fflush(stdout);
        // Move to the next iteration.
        start = end+1;
        end = start + page_bits_size - 1;
    }


    return 0;
}
