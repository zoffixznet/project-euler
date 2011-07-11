/*
 * =====================================================================================
 *
 *       Filename:  euler145.c
 *
 *    Description:  
 *
Some positive integers n have the property that the sum [ n + reverse(n) ]
consists entirely of odd (decimal) digits. For instance, 36 + 63 = 99 and 409 +
904 = 1313. We will call such numbers reversible; so 36, 63, 409, and 904 are
reversible. Leading zeroes are not allowed in either n or reverse(n).

There are 120 reversible numbers below one-thousand.

How many reversible numbers are there below one-billion (109)?

* 
 *        Version:  1.0
 *        Created:  11/07/11 15:35:15
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char * argv[])
{
    int limit;
    int n;

    int count = 0;
    
    limit = atoi(argv[1]);

    for (n = 21 ; n < limit ; )
    {
        int reverse = 0;
        int temp_n = n;

        int power_of_ten = 1;
        while (temp_n)
        {
            reverse = reverse * 10 + (temp_n % 10);
            temp_n /= 10;
            power_of_ten *= 10;
        }

        /*
         * If leading digit is odd, then the last digit of the sum
         * for all the numbers will be even. So we should skip this
         * range.
         * */
        if (reverse & 0x1)
        {
            n += power_of_ten;
            continue;
        }

        int sum = n + reverse;

        while (sum & 0x1)
        {
            sum /= 10;
        }

        if (sum == 0)
        {
            count += 2;
        }

        n += 2;
    }

    printf("Count = %i\n", count);

    return 0;
}
