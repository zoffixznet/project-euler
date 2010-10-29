#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION:

In the following equation x, y, and n are positive integers:

1/x + 1/y = 1/n

For n = 4 there are exactly three distinct solutions:

* 1/5 + 1/20 = 1/4

* 1/6 + 1/12 = 1/4

* 1/8 + 1/8 = 1/4

What is the least value of n for which the number of distinct solutions exceeds one-thousand?

=head1 ANALYSIS

ny + nx = xy

n (x+y) = xy

n = xy / (x+y)

x,y > n

1/y = 1/n-1/x = (x-n)/nx

y = nx/(x-n)

If t = x-n ; x = t + n

y = n*(t+n) / t = n + [ n^2 / t ]

t \in [1 .. n]

2*3
=cut

# use Math::GMP ':constant';

use integer;

for (my $n = 1_000; ;$n++)
{
    my $count = 0;
    my $n_sq = $n * $n;

    for my $t (1 .. $n)
    {
        if (! ($n_sq % $t))
        {
            $count++;
        }
    }
    print "Reached $n [$count]\n";
    if ($count > 1_000)
    {
        print "N = $n\n";
        exit(0);
    }
}
