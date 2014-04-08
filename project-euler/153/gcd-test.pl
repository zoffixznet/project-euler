#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

sub gcd
{
    my ($n, $m) = @_;

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

my ($bb, $aa) = @ARGV;

foreach my $cc (1 .. $bb*$aa)
{
    my $m = $bb*$cc % $aa;
    say join(' ', (($m == 0) ? "T" : "F"), (($cc % ($aa/gcd($aa,$bb)) == 0) ? "T" : "F"));
}
