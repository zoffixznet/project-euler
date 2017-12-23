// The Expat License
//
// Copyright (c) 2017, Shlomi Fish
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <iostream>

const int NUM_DIGITS = 18886117;
const int MAX_SUM = 80846691;

unsigned char digits[NUM_DIGITS];
unsigned int p[MAX_SUM+1];

unsigned int num_found = 0;

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
                num_found++;
            }
        }
        std::cout << "Finished evaluating " << start << ": Found " << num_found << "/" << MAX_SUM << std::endl;
        if (num_found == MAX_SUM+1)
        {
            break;
        }
    }

    std::cout << "Finished calculating p" << std::endl;

    for (unsigned int sum = 1; sum <= MAX_SUM ; sum++)
    {
        std::cout << "p[" << sum << "] = " << p[sum] << std::endl;
    }

    return 0;
}
