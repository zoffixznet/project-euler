#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $n = 3;
my $num_powers = 2;

sub cond
{
    return (($num_powers-1) * 12345 <= ($n-1));
    # return (($num_powers-1) * 13 < ($n-1) * 3);
    # return (($num_powers-1) * 5 < ($n-1) * 2);
}

MAIN:
while (1)
{
    if (cond())
    {
        print "For \$num_powers=$num_powers ; \$n=$n\n";
        last MAIN;
    }
}
continue
{
    $n *= 2;
    $n++;
    $num_powers++;
}

while (cond())
{
    $n--;
}

$n++;

print "N = $n\n";
print "k = ", ($n*$n-$n), "\n";
