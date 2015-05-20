#include <vector>
#include <stdlib.h>
#include <string.h>
#include <iostream>

typedef long long ll;

const long GROW_BY = 1024*16;

const ll DESIRED_K = (100000000000LL - 1);

ll solve(unsigned int n)
{
    std::cout << "Inspecting " << n << std::endl;
    const int AA = 2;
    const int BB = n*2+1;

    const unsigned int CALC_CNT = ((n < 8) ? (1000 << n) : (4000 << n));
    const unsigned int FIND_NUM = (CALC_CNT>>2);
    const unsigned int MAX_STEP = FIND_NUM/2;

    std::vector<int> u;

    u.push_back(AA);
    u.push_back(BB);
    // print "AA\nBB\n";

    long v_size = GROW_BY;
    unsigned char * v = (unsigned char *)malloc(v_size+1);
    memset(v, '\0', v_size+1);
    v[AA+BB] = 1;

    while (u.size() < CALC_CNT)
    {
        int next = -1;
        const int last_elem = u.back();
        const int double_last_elem = last_elem<<1;
        for (int i=last_elem+1; i < double_last_elem; i++)
        {
            if (v[i] == 1)
            {
                next = i;
                break;
            }
        }

        if (next < 0)
        {
            std::cerr << "Next not found!" << std::endl;
            exit(-1);
        }

        const long max_size = next+last_elem;
        if (max_size > v_size)
        {
            const long new_v_size = max_size + GROW_BY;
            v = (unsigned char *)realloc(v, new_v_size+1);
            memset(v+v_size+1, '\0',new_v_size-v_size);
            v_size = new_v_size;
        }
        for (int & prev : u)
        {
            int s = prev+next;
            if (v[s] < 2)
            {
                v[s]++;
            }
        }

        std::cout << next << std::endl;
        u.push_back(next);
    }

    free (v);
    v = NULL;

    const int M = u.size()-1;
    for (unsigned int STEP=1; STEP < MAX_STEP; STEP++)
    {
        const int delta = u[M]-u[M-STEP];

        for (unsigned int i = M-FIND_NUM ; i < M-STEP; i++)
        {
            if (u[i+STEP] - u[i] != delta)
            {
                goto end_of_STEP;
            }
        }
        {
            ll STEP_K = DESIRED_K;
            STEP_K -= ((((STEP_K - M) / STEP) + 1) * STEP);
            return u[STEP_K] + delta * ((DESIRED_K - STEP_K) / STEP);
        }

end_of_STEP:
        ;
    }

    std::cerr << "Cannot find for " << n << "!" << std::endl;
    exit(-1);
    return -1;
}

int main()
{
    ll total_sum = 0;
    for (int n = 2 ; n <= 10; n++)
    {
        total_sum += solve(n);
    }
    std::cout << "Total Sum = " << total_sum << std::endl;
    return 0;
}
