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

typedef long long ll;
typedef uint32_t u32;
typedef unsigned char byte;

const u32 BASE = 20092010;
const int LEN = 2000;
const int PL = LEN - 1;

struct mat_look_t
{
    u32 c[LEN][LEN];
};

struct Mat
{
    // original and transposed.
    mat_look_t orig, trans;
};

Mat ONE;

static void mul(Mat * ret, const Mat * const m_base, const Mat * const n_base)
{
    const typeof(&(m_base->orig)) m = &(m_base->orig);
    const typeof(&(n_base->trans)) n = &(n_base->trans);

    for (int r = 0 ; r < LEN ; r++)
    {
        const u32 * mi = (m->c[r]);
        for (int c = 0; c < LEN ; c++)
        {
            ll sum = 0;
            const u32 * ni = (n->c[c]);
            for (int i = 0; i < LEN ; i++)
            {
                sum = ((sum + (((ll)mi[i]) * ((ll)ni[i]))) % BASE);
            }
            ret->trans.c[c][r] = ret->orig.c[r][c] = (u32)sum;
        }
    }
}

static void power_helper(ll n, Mat * ret);

static void power(ll n, Mat * ret)
{
    char cache_fn[200];
    snprintf(cache_fn, sizeof(cache_fn), "CACHE/%llX.bin", n);
    FILE * cache_fh = fopen(cache_fn, "rb");
    if (! cache_fh)
    {
        power_helper(n,ret);
        FILE * w = fopen(cache_fn, "wb");
        fwrite(ret, sizeof(*ret), 1, w);
        fclose(w);
        cache_fh = fopen(cache_fn, "rb");
    }
    if (fread(ret, sizeof(*ret), 1, cache_fh) != 1)
    {
        fprintf(stderr, "SNAFU for %lld\n" , n);
        exit(-1);
    }
    fclose(cache_fh);
}

static void power_helper(ll n, Mat * ret)
{
    if (n == 1)
    {
        *ret = ONE;
    }
    else if (n & 0x1)
    {
        Mat * temp_ret = new Mat;
        power ((n ^ 0x1), temp_ret);
        printf ("After rec %lld\n", n);
        fflush(stdout);
        mul(ret, temp_ret, &ONE);
        printf ("After mul %lld\n", n);
        fflush(stdout);
        delete temp_ret;
    }
    else
    {
        Mat * rec = new Mat;
        power(n >> 1, rec);
        printf ("After rec %lld\n", n);
        fflush(stdout);
        mul(ret, rec, rec);
        printf ("After mul %lld\n", n);
        fflush(stdout);
        delete rec;
    }
}

int main()
{
    std::vector<ll> v;

    FILE * fh = fopen("primes.txt", "rt");
    while (!feof(fh))
    {
        ll i;
        fscanf(fh, "%lld\n", &i);
        v.push_back(i+1);
    }
    fclose (fh);

    auto iter = v.begin();
    auto end_iter = v.end();
    auto end_item = v.back();

    ll total_sum = 0;

    while (iter != end_iter)
    {
        auto first_item = (*iter);
        std::cout << "Looking at " << first_item << std::endl;

        auto second_item_iter = iter;
        second_item_iter++;

        int count = 0;
        while (second_item_iter != end_iter)
        {
            auto second_item = *(second_item_iter);
            auto second_sq = second_item * second_item;
            auto third_item = (second_sq / first_item);
            if (third_item > end_item)
            {
                break;
            }
            if ((! (third_item & 0x1 )) && (! (second_sq % first_item)) )
            {
                if (std::binary_search(second_item_iter, end_iter, third_item))
                {
                    std::cout << "Found (" << first_item << "," << second_item << "," << third_item << ")" << std::endl;
                    total_sum += first_item + second_item + third_item - 3;
                }
            }
            count++;
            second_item_iter++;
        }
        if (! count)
        {
            break;
        }
        iter++;
    }
    std::cout << "total_sum = " << total_sum << std::endl;

    return 0;
}
