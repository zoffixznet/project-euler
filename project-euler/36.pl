#!/usr/bin/perl

use strict;
use warnings;

my $count;
my $sum = 0;
foreach my $n (1 .. 999_999)
{
    if (    ($n&0x1)
         && (scalar(reverse($n)) eq $n)
    )
    {
        my $b = sprintf("%b", $n);
        if (scalar(reverse($b)) eq $b)
        {
            $count++;
            $sum += $n;
        }
    }
}
print "$count <=> $sum\n";
