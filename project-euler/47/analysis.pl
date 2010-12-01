#!/usr/bin/perl

use strict;
use warnings;

my $n = shift;
my @mods = (0 .. $n-1);
foreach my $a (@mods)
{
    foreach my $b (@mods)
    {
        # print "$a $b ", (($a*$b*$b+1)%$n), "\n";
        print "$a $b ", (((2*$a+1)*(2*$b+1)*(2*$b+1))%$n), "\n";
    }
}
