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
#include <stdlib.h>
#include <algorithm>

typedef long long ll;

typedef u_int16_t u16;
typedef unsigned char byte;

static int O_C[0x10000];

// ll NUM_DIVS = 10;
const ll NUM_DIVS = 5;
const ll MAX = 10000 + 399;
const ll DIV = (( MAX ) / NUM_DIVS + 1);

struct range_t
{
    int start, end;
    range_t()
    {
        start = end = -1;
    }
    range_t(const int s, const int e)
    {
        start = s;
        end = e;
    }
};

static range_t DIM_RANGES[NUM_DIVS];

struct rect_t
{
    range_t dims[3];
};

#define NUM_RECTS 50000

struct depth_t
{
    int dim;
    ll delta;
    int num_rects;
    rect_t rects[NUM_RECTS];
};

static depth_t prev_coords[4];

static ll total_count = 0;

static int XEs[0x10];
static int XSs[0x10];

const long V_SIZE = ( ((DIV * DIV * DIV) >> 4) + 200 );
static u16 v[V_SIZE];

static void rec(const int depth)
{
    depth_t * const remaining = &(prev_coords[depth]);
    if (depth == 3)
    {
        memset(v, 0, sizeof(v));

        const ll y_delta = prev_coords[0].delta;
        const ll z_delta = prev_coords[1].delta * y_delta;

        printf ("Starting for (%d,%d,%d)\n", prev_coords[0].dim, prev_coords[1].dim, prev_coords[2].dim);
        printf ("Evaluating %d Cuboids\n", remaining->num_rects);
        fflush(stdout);
        rect_t * r = remaining->rects;
        typeof ( remaining->num_rects ) num_rects = remaining->num_rects;
        for (int r_idx = 0; r_idx < num_rects ; r++, r_idx++)
        {
            range_t XX = r->dims[0];
            range_t YY = r->dims[1];
            range_t ZZ = r->dims[2];

            printf("Rectangle No. %d\n", r_idx);

            ll z_end = z_delta * ZZ.end;
            for (ll z = z_delta * ZZ.start; z <= z_end; z += z_delta)
            {
                ll y_end = z + YY.end * y_delta;
                for (ll y = z + y_delta * YY.start; y <= y_end; y += y_delta)
                {
                    // print ":COUNT:=@$XX,@$YY,@$ZZ => $count\n";
                    ll x_start = (y + XX.start);
                    ll x_end = (y + XX.end);

                    ll byte_start = (x_start >> 4);
                    ll byte_end = (x_end >> 4);
                    if (byte_start == byte_end)
                    {
                        v[byte_start] |= (((1 << (x_end-x_start+1))-1) << (x_start & 0xF));
                    }
                    else
                    {
                        v[byte_start] |= XSs[x_start & 0xF];
                        // This is a funky way to do $count += 16 - $O_C[byte]
                        // for every byte, where 16 is the number of bit counts.
                        for (ll x = byte_start + 1; x < byte_end; x++)
                        {
                            v[x] = 0xFFFF;
                        }
                        v[byte_end] |= XEs[x_end & 0xF];
                    }
                    // print ":COUNT:=@$XX,@$YY,@$ZZ => $count\n";
                }
            }
        }

        ll count = 0;
        u16 * v_end = &(v[V_SIZE]);
        for (u16 * v_ptr = v; v_ptr < v_end; v_ptr++)
        {
            count += O_C[*v_ptr];
#if 0
            if (count < 0)
            {
                fprintf(stderr , "Foo!\n");
            }
#endif
        }

        total_count += count;
        printf ("Found Count = %lld for (%d,%d,%d) for a total of TotalCount = %lld\n" , count, prev_coords[0].dim, prev_coords[1].dim, prev_coords[2].dim, total_count);
        fflush(stdout);
    }
    else
    {
        const typeof(depth) dim = depth;
        for (int dim_i=0 ; dim_i < NUM_DIVS; dim_i++)
        {
            const range_t X_RANGE = DIM_RANGES[dim_i];

            const int S = X_RANGE.start;
            const int E = X_RANGE.end - S;

            prev_coords[dim + 1].num_rects = 0;
            rect_t * rects = prev_coords[dim + 1].rects;

            rect_t * r_end = remaining->rects + remaining->num_rects;
            // Populate @rects.
            for (rect_t * r = remaining->rects; r < r_end ; r++)
            {
                rect_t p = *r;

                int s = p.dims[dim].start-S;
                if (s > E)
                {
                    continue;
                }
                if (s < 0)
                {
                    s = 0;
                }

                int e = p.dims[dim].end - S;
                if (e < 0)
                {
                    continue;
                }
                if (e > E)
                {
                    e = E;
                }

                p.dims[dim] = range_t(s,e);
                *(rects++) = p;
            }
            prev_coords[dim + 1].num_rects = rects - prev_coords[dim + 1].rects;
            prev_coords[dim].delta = E+1;
            prev_coords[dim].dim = dim_i;
            rec(depth + 1);
        }
    }

    return;
}


static inline int bit_count(int from)
{
    return ((from == 0) ? 0 : ((from&0x1)+bit_count(from >> 1)));
}

int main()
{
    {
        for (int from=0; from <= 0xFFFF ; from++)
        {
            O_C[from] = bit_count(from);
        }
    }

    DIM_RANGES[0] = range_t(0, DIV-1);
    for (int i = 1; i < NUM_DIVS; i++)
    {
        const int start = DIM_RANGES[i-1].end+1;
        const int end = std::min(start + DIV - 1, MAX);
        DIM_RANGES[i] = range_t(start, end);
    }

    {
        FILE * f = fopen("rects_cache.txt", "rt");
        for (int i = 0 ; i < NUM_RECTS; i++)
        {
            rect_t * r = &(prev_coords[0].rects[i]);
            fscanf(f, "%d %d %d %d %d %d",
                &(r->dims[0].start),
                &(r->dims[0].end),
                &(r->dims[1].start),
                &(r->dims[1].end),
                &(r->dims[2].start),
                &(r->dims[2].end)
            );
        }
        fclose(f);
        prev_coords[0].num_rects = NUM_RECTS;
    }
    {
        if (char * filter = getenv("COUNT"))
        {
            prev_coords[0].num_rects = atoi(filter);
        }
    }

    {
        for (int i = 0; i <= 0xF ; i++)
        {
            XEs[i] = ((1 << (1+(i & 0xF)))- 1);
            XSs[i] = (0xFFFF ^ ((1 << (i & 0xF))-1));
        }
    }

    rec(0);

    return 0;
}
