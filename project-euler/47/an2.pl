#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils (qw(all));

my $n = shift;
my @array = ();
foreach my $a (2 .. $n)
{
    foreach my $b (2 .. $n)
    {
        $array[$a*$a*$b] = 1;
    }
}

foreach my $idx (0 .. $#array-3)
{
    if (all { $_ } @array[$idx..$idx+3])
    {
        print "Four consecutive multiple of squares at $idx\n";
    }
}
