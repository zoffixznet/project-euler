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
#include <assert.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>

typedef long long ll;
typedef uint32_t u32;
typedef unsigned char byte;

const u32 BASE = 20092010;
const int LEN = 2000;
const int PL = LEN - 1;

int main()
{
    std::vector<ll> v;
    std::map<ll,ll> squares;
    ll max = 0, max_sq = 0;

    FILE * fh = fopen("primes.txt", "rt");
    while (!feof(fh))
    {
        ll i;
        fscanf(fh, "%lld\n", &i);
        const ll i1 = i+1;
        v.push_back(i1);

        const ll isq = i1*i1;
        squares[isq] = i1;
        if (i1 > max)
        {
            max = i1;
            max_sq = isq;
        }
    }
    fclose (fh);

    auto iter = v.begin();
    auto end_iter = v.end();

    ll total_sum = 0;

    while (iter != end_iter)
    {
        auto first_item = (*iter);
        std::cout << "Looking at " << first_item << std::endl;

        auto second_item_iter = iter;
        second_item_iter++;

        while (second_item_iter != end_iter)
        {
            const auto second_item = *(second_item_iter);
            const auto product = second_item * first_item;
            if (product > max_sq)
            {
                break;
            }
            auto sq = squares.find(product);
            if (sq != squares.end())
            {
                const auto third_item = sq->second;
                std::cout << "Found (" << first_item << "," << second_item << "," << third_item << ")" << std::endl;
                total_sum += first_item + second_item + third_item - 3;
            }
            second_item_iter++;
        }
        squares.erase(first_item*first_item);
        iter++;
    }
    std::cout << "total_sum = " << total_sum << std::endl;

    return 0;
}
