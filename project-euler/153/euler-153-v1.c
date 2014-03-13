#include <stdio.h>

typedef int64_t myint_t;

static inline myint_t min(const myint_t a, const myint_t b)
{
    return ((a < b) ? a : b);
}

static inline myint_t gcd(myint_t n, myint_t m)
{
    if (m > n)
    {
        return gcd(m,n);
    }
    while (m > 0)
    {
        myint_t new_m = n%m;
        n = m;
        m = new_m;
    }
    return n;
}

static inline myint_t sq(const myint_t x)
{
    return x*x;
}

static inline myint_t helper(const myint_t MAX, const myint_t aa, const myint_t bb)
{
    /* print "a=$aa b=$bb\n";

# Question: when is ($cc*$bb/$aa) an integer?
#
# Answer: when $cc*$bb mod $aa == 0
# That happens when $cc is a product of $aa/gcd($aa,$bb)
*/

    const myint_t cc_step = aa / gcd(bb, aa);

    const myint_t max_cc = min(
        aa,
        MAX/(aa*(1 + (bb/aa)**2))
    );

    const myint_t cc_num_steps = ((max_cc-1) / cc_step );
    /*
        Sum of $aa+$cc_step + $aa + 2*$cc_step + $aa + 3 * $cc_step
        up to $aa + $cc_step*($cc_num_steps)
     */
    const myint_t cc = cc_step * (cc_num_steps+1);

    return cc_num_steps * (aa + (cc>>1))
        + (
            (cc == max_cc)
            ? (aa +
                (
                    (cc == aa)
                    ? 0
                    : cc
                    )
                )
            : 0
          );

}

static inline calc_sum(const myint_t MAX)
{
    myint_t ret = 0;

    const myint_t MAX_SQ = sq(MAX);

    for (myint_t aa = 1; aa <= MAX; aa++)
    {
        printf ("a=%lld\n", ((long long)aa));

        ret += helper(MAX, aa, 0);
        myint_t d = 0;
        const myint_t max_bb = (myint_t)(sqrt($MAX_SQ - $aa*$aa));
        for (myint_t bb = 1; bb <= max_bb; bb++)
        {
            d += helper(MAX, aa, bb);
        }
        ret += d << 1;
    }

    return ret;
}

int main(int argc, char * argv[])
{
    printf ("%lld\n", ((long long)calc_sum(atol(argv[1])));
}
