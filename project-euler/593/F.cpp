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
    fclose(remove);
    fclose(in);
    std::cout << "Sum = " << (sum >> 1) << (((sum&0x1) == 0) ? ".0" : ".5") <<
        std::endl;
    return 0;
}
