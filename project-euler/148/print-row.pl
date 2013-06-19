#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

sub fact
{
    return shift->copy->bfac;
}

sub nCr
{
    my ($n, $k) = @_;
    $n += 0;
    $k += 0;
    return fact($n) / (fact($n-$k) * fact($k));
}

my $n = shift(@ARGV);

print join(' ', map { +(nCr($n-1, $_) % 7 == 0 ) ? 'Y' : 'N' } (1 .. $n-2)), "\n";
