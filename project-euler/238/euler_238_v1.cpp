#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <iostream>

const int NUM_DIGITS = 18886117;
const int MAX_SUM = 80846691;

unsigned char digits[NUM_DIGITS];
unsigned int p[MAX_SUM+1];

int main(int argc, char * argv[])
{
    memset(p, '\0', sizeof(p));
    {
        FILE * f = fopen("input.txt", "r");
        int i = 0;
        while (!feof(f))
        {
            unsigned char buf[1024];

            const int num_read = fread (buf, sizeof(buf[0]), sizeof(buf), f);

            for (int j=0;j<num_read;j++)
            {
                digits[i++] = buf[j]-'0';
            }
        }
        assert (i == NUM_DIGITS);
        fclose (f);
    }

    std::cout << "Finished reading file" << std::endl;

    for (int start = 0; start < NUM_DIGITS ; start++)
    {
        std::cout << "Evaluating " << start << std::endl;
        if (start && (!digits[start-1]))
        {
            continue;
        }
        const int p_val = start+1;

        unsigned char * d_ptr = &(digits[start]);
        unsigned int sum = 0;
        for (int num = 0; num < NUM_DIGITS ; num++)
        {
            if (d_ptr == digits+NUM_DIGITS)
            {
                d_ptr = digits;
            }
            sum += *(d_ptr++);
            if (! p[sum])
            {
                p[sum] = p_val;
            }
        }
    }

    std::cout << "Finished calculating p" << std::endl;

    for (unsigned int sum = 1; sum <= MAX_SUM ; sum++)
    {
        std::cout << "p[" << sum << "] = " << p[sum] << std::endl;
    }

    return 0;
}
