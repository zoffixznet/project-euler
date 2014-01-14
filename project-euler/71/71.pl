#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt try => "GMP";
use Math::BigRat try => "GMP";

sub find_numerator
{
    my $d = shift;

    if ($d % 7 == 0)
    {
        return;
    }

    my $n = int (($d * 3) / 7);

    if (Math::BigInt::bgcd($n, $d) != 1)
    {
        return;
    }
    else
    {
        return $n;
    }
}

sub find_rat
{
    my $d = shift;
    my $n = find_numerator($d);

    if (!defined($n))
    {
        return;
    }
    else
    {
        return Math::BigRat->new("$n/$d");
    }
}

my $top = Math::BigRat->new('3/7');
my $d = 1_000_000;
my $bottom = find_rat($d);

for (; $d >= 7 ; $d--)
{
    if ($d % 10_000 == 0)
    {
        print "d=$d\n";
    }
    my $to_check = find_rat($d);

    if ($to_check && ($to_check > $bottom))
    {
        $bottom = $to_check;
        print "New bottom - $bottom (d=$d)\n";
    }
}
