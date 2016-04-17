#!/usr/bin/perl
# Adapted by Shlomi Fish.
#
# Solution for:
#
# http://projecteuler.net/problem=23

use strict;
use warnings;

use feature qw/say/;

my @divisors_sums;
$divisors_sums[1] = 0;

my $MAX = 28_123;
foreach my $div (1 .. ($MAX >> 1))
{
    my $prod = ($div<<1);
    while ($prod <= $MAX)
    {
        $divisors_sums[$prod] += $div;
    }
    continue
    {
        $prod += $div;
    }
}

# Memoized.
#
my $is_abundant_sum = '';

my @abundants;
my $total = 0;
foreach my $num (1 .. $MAX)
{
    if ($divisors_sums[$num] > $num)
    {
        push @abundants, $num;
        INNER:
        foreach my $i (@abundants)
        {
            my $s = $i+$num;
            if ($s > $MAX)
            {
                last INNER;
            }
            if (! vec($is_abundant_sum, $s, 1))
            {
                $total += $s;
                vec($is_abundant_sum, $s, 1) = 1;
            }
        }
    }
}

say "Sum == ", ((((1 + $MAX) * $MAX) >> 1)-$total);
