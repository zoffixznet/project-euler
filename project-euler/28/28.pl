#!/usr/bin/perl

use strict;
use warnings;

my $sum = 0;

my $num = 1;

$sum += $num;

my $step = 0;
foreach my $square ( grep { $_ % 2 == 1 } 3 .. 1001 )
{
    $step += 2;

    foreach my $side ( 0 .. 3 )
    {
        $num += $step;
        $sum += $num;
    }
}
print "Sum = $sum\n";
