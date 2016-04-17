#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);



my $count = 0;

foreach my $n (2 .. 10_000_000)
{
    if ($n % 10_000 == 0)
    {
        print "$n [$count]\n";
    }
    my $i = $n;
    while (($i != 1) && ($i != 89))
    {
        $i = (sum map { $_ * $_ } split//,$i)
    }
    if ($i == 89)
    {
        $count++;
    }
}

print "Count = $count\n";
