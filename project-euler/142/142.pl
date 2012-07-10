#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

# use Math::BigInt lib => 'GMP';

sub is_square
{
    my $n = shift;

    # my $root = int($n->copy->bsqrt());
    my $root = int(sqrt($n));

    return ($root * $root == $n);
}

foreach my $x (1 .. 1_000_000)
{
    Y_LOOP:
    foreach my $y (1 .. $x-1)
    {
        if (!is_square($x+$y) or !is_square($x-$y))
        {
            next Y_LOOP;
        }
        print "Reached X=$x Y=$y\n";
        foreach my $z (1 .. $y-1)
        {
            if (is_square($y+$z) and is_square($y-$z) and is_square($x-$z)
                    and is_square($x+$z))
            {
                print "Found X=$x Y=$y Z=$z S=@{[$x+$y+$z]}\n";
                exit(0);
            }
        }
    }
}
