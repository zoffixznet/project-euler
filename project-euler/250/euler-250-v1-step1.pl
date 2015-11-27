#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;

my @counts;
for my $n (1 .. 250_250)
{
    $counts[(Math::GMP->new($n)->powm_gmp($n, 250)) . '']++;
}
while (my ($mod, $c) = each@counts)
{
    if (defined($c))
    {
        print "$mod: $c\n";
    }
}
