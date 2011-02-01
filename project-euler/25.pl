#!/usr/bin/perl 

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

my $f1 = 1;
my $f2 = 1;

my $i1 = 1;
while (length("$f1") != 1000)
{
    ($f1, $f2) = ($f2, $f1+$f2);
    $i1++;
}
print "$i1\n";

