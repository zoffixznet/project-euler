#include <boost/countertree/set.hpp>
#include <cstdio>
#include <iostream>

static inline int read_int(FILE *const f)
{
    int ret;
    fscanf(f, "%d", &ret);
    return ret;
}

int main(int argc, char * argv[])
{
    const int n = std::stoi(argv[1]);
    const int k = std::stoi(argv[2]);

    countertree::multiset<int> myset;
    FILE * in = fopen("S2.txt", "r");
    for (int i = 0; i < k; i++) {
        myset.insert(read_int(in));
    }
    FILE * remove = fopen("S2.txt", "r");
    long long sum = 0;
    for (int i = 1; i <= n-k+1; i++) {
        sum += myset.pos((k-1) >> 1) + myset.pos((k) >> 1);
#if 0
        std::cout << "Sum[" << i << "] = " << sum << std::endl;
#endif
        myset.insert(read_int(in));
        const auto it = myset.find(read_int(remove));
        myset.erase(it);
    }
    std::cout << "Sum = " << (sum >> 1) << (((sum&0x1) == 0) ? ".0" : ".5") <<
        std::endl;
    return 0;
}
