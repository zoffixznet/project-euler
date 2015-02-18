#include <iostream>
#include <set>
#include <map>
#include <cstdio>
#include <cmath>
#include <cstdlib>
#include <algorithm>

typedef long long LL;

std::set<LL> squares;
/*
my %squares = (map { _ * _ => undef() } 1 .. 999_999);
# my sum = 0;
*/

int d;
LL d3;

void divisors(LL r, std::map<int,int> & factors, const std::map<int,int>::iterator this_)
{
    if (this_ == factors.end())
    {
        /* Handle the stuff. */
        LL n = (r + d3 / r);

        if (squares.find(n) != squares.end())
        {
            if (n % d == r)
            {
                LL i[3] = {n/d,d,r};
                std::sort(std::begin(i), std::end(i));
                if (i[1] * i[1] == i[0] * i[2])
                {
                    printf( "Found for d=%d r=%lld q=%lld n=%lld\n",
                        d, r, n/d, n
                    );
                    fflush(stdout);
                }
            }
        }
    }
    else
    {
        std::map<int,int>::iterator rest(this_);
        rest++;

        int b = (*this_).first;
        int e = (*this_).second;

        for (int i = 0 ; i <= e ; i++)
        {
            if (r >= d)
            {
                break;
            }
            divisors(r, factors, rest);
            r *= b;
        }
    }
}

int main()
{
    for (LL i = 0 ; i <= 999999 ; i++)
    {
        squares.insert(i*i);
    }

    FILE * f = fopen("factors.txt", "rt");
    for (d = 2; d < 1000000 ; d++)
    {
        if (d % 1000 == 0)
        {
            printf( "D=%d\n", d);
            fflush(stdout);
        }
        d3 = ((LL)d) * d * d;

        std::map<int,int> factors;
        int factor;
        while (fscanf(f, "%d", &factor) == 1)
        {
            if (factor == -1)
            {
                break;
            }
            factors[factor] += 3;
        }

        divisors(1, factors, factors.begin());
    }
    fclose (f);

    return 0;
}

