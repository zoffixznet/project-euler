#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use List::Util qw(sum min);

my @sums;

@{$sums[0]} = ((1) x 101);
$sums[1][0] = 0;
$sums[1][1] = 1;

foreach my $total_sum (2 .. 100)
{
    $sums[$total_sum][0] = 0;
    foreach my $max (1 .. $total_sum)
    {
        my $remains = $total_sum - $max;
        my $count = sum(@{$sums[$remains]}[0 .. min($max, $remains)]);
        print "Count-sums--of-$total_sum-with-max=$max = $count\n";
        $sums[$total_sum][$max] = $count;
    }
}

print "Answer = ", sum(@{$sums[100]}[0 .. 99]), "\n";

