#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

use List::Util qw(sum);

my $bottom_power_nums = [];

for (my $top_n = 2; ; $top_n++)
{
    foreach my $base (2 .. $top_n)
    {
        my $power_num = $base ** $top_n;

        if (sum(split//, $power_num.q{}) == $base)
        {
            push @$bottom_power_nums, $power_num;
        }
    }

    foreach my $exp (2 .. $top_n)
    {
        my $power_num = $top_n ** $exp;

        if (sum(split//, $power_num.q{}) == $top_n)
        {
            push @$bottom_power_nums, $power_num;
        }
    }

    # Trim the list if needed.
    my @new = sort { $a <=> $b } @$bottom_power_nums;
    splice(@new, 30);
    $bottom_power_nums = \@new;

    # Write the debugging stuff.
    print "Reached $top_n\n";
    foreach my $i (0 .. $#$bottom_power_nums)
    {
        print "PowerNum[" , $i+1, "] = ", $bottom_power_nums->[$i], "\n";
    }
}
