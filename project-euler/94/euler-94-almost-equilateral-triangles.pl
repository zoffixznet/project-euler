#!/usr/bin/perl

use strict;
use warnings;

use Math::BigFloat lib => "GMP", ":constant";
use IO::Handle;

STDOUT->autoflush(1);

# There are two types of almost-equilateral triangles:
# 1. $n, $n, $n-1
# 2. $n, $n, $n+1

# For No. 1 we need a triangle for whose ($n-1) * sqrt($n^2 - (($n-1)/2)^2) is
# integral.
# 
# For No. 2 we need a triangle for whose ($n+1) * sqrt($n^2 - (($n+1)/2)^2) is
# integral.
# 

my $sum = 0;

foreach my $n (1 .. 1_000_000_000)
{
    my $v = (($n-1) * sqrt($n**2 - (($n-1)/2)**2));
    if (int($v) == $v)
    {
        print $n, "\n";
    }
}
