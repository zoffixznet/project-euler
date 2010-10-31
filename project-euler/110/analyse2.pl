#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP;
use List::Util qw(reduce);

sub log10
{
    my $n = shift;
    return log($n)/log(10);
}


my @primes = (qw(2 3 5 7 11 13 17 19 23 29 31 37 41 43));

my @prime_logs = map { log10($_) } @primes;

print join(",", @prime_logs), "\n";

my @
