#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my ($MAX) = @ARGV;

my $sum = 0;

for my $r (1 .. $MAX)
{
    # print "R=$r - adding ", int ($MAX / $r) * $r, "\n";
    $sum += int ($MAX / $r) * $r;

    I:
    for my $i (1 .. $MAX)
    {
        my $x = $r*$r+$i*$i;
        if ($x > $MAX)
        {
            last I;
        }

        for my $m (1 .. $MAX / $x)
        {
            $sum += int ($MAX / ($x * $m)) * (2 * $r * $m);
        }
        # print "C=($r+i*$i) - adding ", int ($MAX / $x) * (2 * $r) , "\n";
    }
}

print "Sum = $sum\n";
