#!/usr/bin/perl 

use strict;
use warnings;

use Math::BigInt qw(:constant);

sub fact
{
    my $n = shift;
    my $prod = 1;
    for my $i (1 .. $n)
    {
        $prod *= $i;
    }
    return $prod;
}

printf "%s\n", (fact(40)/(fact(20)*fact(20)));
