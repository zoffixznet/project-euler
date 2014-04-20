#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my $n = 10;

my $sum = 0;
while (1)
{
    if (sum(map { $_ ** 5 } split(//, $n)) == $n)
    {
        $sum += $n;
        print "$n : $sum\n"
    }
    $n++;
}
