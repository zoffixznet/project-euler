#!/usr/bin/perl

use strict;
use warnings;

my $n = 4;
my $num_powers = 2;

MAIN:
while (1)
{
    if (($num_powers-1) / ($n-2) < 1/12345)
    {
        print "For \$num_powers=$num_powers ; \$n=$n\n";
        last MAIN;
    }
}
continue
{
    $n *= 2;
    $num_powers++;
}

while (($num_powers-1) / ($n-2) < 1/12345)
{
    $n--;
}

$n++;
$n++;

print "N=$n\n";
print "k = ", ($n*$n-$n), "\n";
