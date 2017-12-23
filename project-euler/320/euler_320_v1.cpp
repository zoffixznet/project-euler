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

#include <gmpxx.h>
#include <map>
#include <fstream>
#include <iostream>
#include <vector>
#include <string>
#include <sstream>

typedef mpz_class ll;

ll factorial_factor_exp(const ll & n, const ll & f)
{
    if (n < f)
    {
        return 0;
    }
    else
    {
        ll div = n / f;
        return div + factorial_factor_exp(div, f);
    }
}

// Finds the minimal n-factorial whose exponent is larger than e
ll find_exp_factorial(const ll & f, const ll & e, const ll & bottom, const ll & top)
{
#define find(bb, tt) find_exp_factorial(f, e, bb, tt)
    if (bottom > top)
    {
        return top;
    }
    ll top_val = factorial_factor_exp(top, f);

    if (top_val < e)
    {
        return find(top, top << 1);
    }
    ll bottom_val = factorial_factor_exp(bottom, f);
    if (bottom_val < e and (top == bottom + 1))
    {
        return top;
    }


    ll mid = ((bottom + top) >> 1);
    ll mid_val = factorial_factor_exp(mid, f);

    if (mid_val < e)
    {
        return find(mid, top);
    }
    return find(bottom, mid);
#undef find
}

struct Rec
{
    int f;
    ll e, v;
    Rec(int new_f) { f = new_f; e = 0; v = 1; }
};

std::map<int, Rec *> factors_exp;

struct Rec_cmp
{
    bool operator()(const Rec * A, const Rec * B) const
    {
        if (A->v < B->v)
        {
            return true;
        }
        if (A->v == B->v && A->f < B->f)
        {
            return true;
        }
        return false;
    }
};

// taken from http://stackoverflow.com/questions/236129/split-a-string-in-c
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}

std::map<Rec *, Rec *, Rec_cmp> tree;
// This is the S function
void sum_factorials(int n)
{
    std::ifstream fh("./factors-2-to-1000000.txt");

    ll mult("1234567890");

    auto read_line = [& fh, mult] () {
        std::string line;
        std::getline(fh, line);

        std::vector<std::string> factors = split(line, ',');

        for (unsigned int f_idx = 0 ; f_idx < factors.size(); f_idx += 2)
        {
            int f = std::stoi(factors[f_idx]);
            int e = std::stoi(factors[f_idx+1]);

            if (!factors_exp.count(f))
            {
                Rec * rec = new Rec(f);
                factors_exp.insert(std::pair<int, Rec *>(f, rec));
                tree.insert(std::pair<Rec *,Rec *>(rec, rec));
            }
            Rec * rec = factors_exp[f];

            tree.erase(rec);

            rec->e += mult * e;
            rec->v = find_exp_factorial(f, rec->e, rec->v, rec->v << 1);

            tree.insert(std::pair<Rec *,Rec *>(rec, rec));
        }
    };

    for (int i = 2; i<=9 ; i++)
    {
        read_line();
    }

    ll S(0);
    ll BASE("1000000000000000000");
    for (int i = 10; i <= n ; i++)
    {
        read_line();
        Rec * L;
        auto it = tree.rbegin();
        L = (*it).first;
        S += L->v;
        std::cout << i << " : F = " << L->f << " ; S = " << S << " ; Smod = " << (S % BASE) << std::endl;
    }

    return;
}

int main(int argc, char * argv[])
{
    sum_factorials(std::stoi(argv[1]));
    return 0;
}

