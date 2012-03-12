#!/usr/bin/perl

use strict;
use warnings;

use Math::BigRat lib => 'GMP';

my $h = 1;

my $c2 = Math::BigRat->new('5/4');
my $c0 = Math::BigRat->new('1/4');
my $c1_p = Math::BigRat->new('1/2');
my $c1_m = Math::BigRat->new('-1/2');

while (1)
{
    foreach my $c1 ($c1_m, $c1_p)
    {
        my $L = ($c0 + $h*($c1 + $h*$c2))->bsqrt();
        my $L_int = $L->as_int();
        if ($L_int == $L)
        {
            print "Found $L_int\n";
        }
    }
}
continue
{
    $h+=2;
}
