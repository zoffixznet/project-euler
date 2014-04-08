#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

my %numbers;

for my $base (2 .. 100)
{
    for my $expt (2 .. 100)
    {
        my $r = Math::BigInt->new($base) ** Math::BigInt->new($expt);
        $numbers{"$r"}++;
    }
}

print keys(%numbers);
