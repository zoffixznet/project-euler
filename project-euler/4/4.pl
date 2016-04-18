#!/usr/bin/perl

use strict;
use warnings;

my $max = 0;
for my $i (100 .. 999)
{
    for my $j (100 .. 999)
    {
        my $n = $i*$j;
        if ($n == scalar(reverse($n)) && ($n > $max))
        {
            $max = $n;
        }
    }
}
print "$max\n";

