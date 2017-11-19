#include <stdio.h>
#include <string.h>
#include <string>

typedef unsigned __int128 ll;

std::string ll2s(const ll n)
{
    char s[2] = {0,0};
    if (n == 0)
    {
        return std::string("");
    }
    s[0] = '0' + n % 10;
    return ll2s(n / 10) + std::string(s);
}

const ll MAX = 1000000000000LL;

int main()
{
    char cmd[100];
    snprintf(cmd, sizeof(cmd), "primesieve -p 1000160 1000000000000");

    FILE * f = popen(cmd, "r");

    ll c = 0, s = 0, d = 1000000;
    ll inv = MAX / d;
    const ll MIN_d = 28;

    while (true)
    {
        unsigned long long p;
        fscanf(f, "%llu", &p);
        while (p > inv)
        {
            printf("d = %d count = %s sum = %s\n", (int)d, ll2s(c).c_str(), ll2s(s).c_str());
            fflush(stdout);
            if (--d == MIN_d)
            {
                pclose(f);
                return 0;
            }
            inv = MAX / d;
        }
        ++c;
        s += p;
    }
    return -1;
}
