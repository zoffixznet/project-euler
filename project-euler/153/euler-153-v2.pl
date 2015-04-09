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

sub gcd
{
    my ($n, $m) = @_;

    if ($m > $n)
    {
        ($n, $m) = ($m, $n);
    }

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}
for my $r (1 .. $MAX)
{
    print "R=$r - adding ", int ($MAX / $r) * $r, "\n";
    $sum += int ($MAX / $r) * $r;

    I:
    for my $i (1 .. $MAX)
    {
        if (gcd($i, $r) == 1)
        {
            my $x = $r*$r+$i*$i;
            if ($x > $MAX)
            {
                last I;
            }

            for my $m (1 .. $MAX / $x)
            {
                print "C=(@{[$r*$m]}+i*@{[$m*$i]}) - adding ", int ($MAX / ($x * $m)) * (2 * $r * $m) , "\n";
                $sum += int ($MAX / ($x * $m)) * (2 * $r * $m);
            }
        }
    }
}

print "Sum = $sum\n";
