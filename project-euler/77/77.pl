#!/usr/bin/perl

use strict;
use warnings;

my @primes = `primes 2 10000`;
chomp(@primes);

my @c_of_n_and_m;

$c_of_n_and_m[2][2] = 1;

foreach my $n (3 .. 500)
{
    foreach my $p (
}
