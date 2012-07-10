#!/usr/bin/perl

use strict;
use warnings;

use integer;

use IO::All;

# use Math::BigInt lib => 'GMP';

sub is_square
{
    my $n = shift;

    # my $root = int($n->copy->bsqrt());
    my $root = int(sqrt($n));

    return ($root * $root == $n);
}

my $milestone_step = 10_000;
my $next_milestone = $milestone_step;

foreach my $x (1 .. 1_000_000)
{
    my $x_diff = 1;
    Y_LOOP:
    for (my $y = $x-1 ; $y > 0 ; $y -= ($x_diff += 2))
    {
        if (!is_square($x+$y))
        {
            next Y_LOOP;
        }
        if ($x >= $next_milestone)
        {
            print "Reached X=$x Y=$y\n";
            $next_milestone += $milestone_step;
        }

        my $y_diff = 1;
        for (my $z = $y-1 ; $z > 0 ; $z -= ($y_diff += 2))
        {
            if (is_square($y+$z) and is_square($x-$z)
                    and is_square($x+$z))
            {
                print "Found X=$x Y=$y Z=$z S=@{[$x+$y+$z]}\n";
                exit(0);
            }
        }
    }
}
