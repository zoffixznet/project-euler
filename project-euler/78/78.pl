#!/usr/bin/perl

use strict;
use warnings;
use IO::Handle;

use 5.010;

use List::Util qw(sum min);
use Math::BigInt (":constant", lib => 'GMP');

STDOUT->autoflush(1);

my @sums;

$sums[1][0] = 0;
$sums[1][1] = 1;

my $total_sum = 2;
TOTAL_SUM_LOOP:
while (1)
{
    print "N = $total_sum\n";
    $sums[$total_sum][0] = 0;
    foreach my $max (1 .. $total_sum)
    {
        my $remains = $total_sum - $max;
        my $count =
            (($remains == 0)
                ? 1 :
                sum(@{$sums[$remains]}[0 .. min($max, $remains)])
            );
        # print "Count-sums--of-$total_sum-with-max=$max = $count\n";
        $sums[$total_sum][$max] = $count;
    }

    my $v = sum(@{$sums[$total_sum]});
    print "V = $v\n";
    if ($v % 1_000_000 == 0)
    {
        print "Found for $total_sum\n";
        last TOTAL_SUM_LOOP;
    }
}
continue
{
    $total_sum++;
}
