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
    my $limit = int(sqrt($x));
    Y_LOOP:
    foreach my $diff_root (1 .. $limit)
    {
        my $y = $x - $diff_root * $diff_root;
        if (!is_square($x+$y))
        {
            next Y_LOOP;
        }
        print "Reached X=$x Y=$y\n";

        my $y_limit = int(sqrt($y));
        foreach my $y_diff_root (1 .. $y_limit)
        {
            my $z = $y - $y_diff_root * $y_diff_root;
            if (is_square($y+$z) and is_square($x-$z)
                    and is_square($x+$z))
            {
                print "Found X=$x Y=$y Z=$z S=@{[$x+$y+$z]}\n";
                exit(0);
            }
        }
    }
}
