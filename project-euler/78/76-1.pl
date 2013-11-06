#!/usr/bin/perl

use strict;
use warnings;

use 5.010;

use List::Util qw(sum min max);
use Math::BigInt lib => 'GMP';

no warnings 'recursion';

# An array of arrays - 
# First index is the sum.
# Second index is the maximal possible element
my @num_sums;

$num_sums[1][1] = Math::BigInt->new(1);

sub calc_num_sum
{
    my ($sum, $max) = @_;

    print "Calling calc_num_sum($sum,$max)\n";

    print("CalcSum[$sum][$max]\n");

    $max = min($max,$sum);

    if ($max == $sum)
    {
        return $num_sums[$sum][$max] //= 1;
    }

    my $ret =
    (
        $num_sums[$sum][$max] //=
        do
        {
            my $count = Math::BigInt->new(0);
            foreach my $first (1 .. $max)
            {
                my $tail_sum = $sum-$first;

                $count += ($num_sums[$tail_sum][$first] //= 
                    calc_num_sum($tail_sum, $first)
                );
            }

            $count;
        }
    );

    print "Sum[$sum][$max] = $ret\n";

    return $ret;
}

calc_num_sum(100,99);

