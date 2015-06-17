#!/usr/bin/perl

use strict;
use warnings;

use integer;

my $count_digits = shift(@ARGV);

my @counts;

for my $n (0 .. ('9' x $count_digits))
{
    my $n0 = sprintf("%0${count_digits}d", $n);

    my @odds = (grep { my @x = $n0 =~ /$_/g; @x & 0x1; } 0 .. 9);

    $counts[@odds/2]++;
}
print "@counts\n";
