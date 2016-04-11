#include <cstdio>
#include <algorithm>

typedef long long ll;

#if 1
const int m = 1000000;
const int p = 1000000;
#else
const int m = 1000;
const int p = 1000;
#endif

int main(int argc, char * argv[])
{
    ll ret = 0;
    for (int k = 2; k <= p ; k++)
    {
        printf ("k=%d\n", k);
        int s = 1;
        if ((k & 0x1) == 0)
        {
            s = (k >> 1);
            // Short for wavelen
            int w = k - s;
            // Short for delta
            int d = w - s;
            ll min_ = m - s + 1;
            ll max_ = m + std::min(d, 0);
            ret += (((min_+max_)*(max_-min_+1)));
            s++;
        }
        s = std::max(s, ((k<<1) / 3));
        // Short for wavelen
        auto w = k - s;
        // Short for delta
        auto d = w - s;
        ll min_ = m - s + 1;
        ll max_ = m + std::min(d, 0);
        if (max_ >= min_)
        {
            for (auto i = s; i < k ; i++)
            {
                if ((d % w) == 0)
                {
                    ret += (((min_+max_)*(max_-min_+1)));
                }
                w--;
                min_--;
                if ((d -= 2) < 0)
                {
                    max_--;
                    if (d < -1)
                    {
                        max_--;
                    }
                    if (max_ < min_)
                    {
                        break;
                    }
                }
            }
        }
    }
    printf( "sum = %lld\n", (ret>>1));
    return 0;
}

