#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

my $A = 5;

for (my $n = 1; $n < 1_000 ; $n++)
{
    print "$n: ";
    print +(
        ( ((($A - 1) ** $n) + (($A + 1) ** $n)) % ($A * $A) ), 
        "\n",
    );
}
