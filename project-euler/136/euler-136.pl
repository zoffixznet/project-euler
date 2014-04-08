#!/usr/bin/perl

use strict;
use warnings;

use integer;

use IO::Handle;

STDOUT->autoflush(1);

=head1 DESCRIPTION

The positive integers, x, y, and z, are consecutive terms of an arithmetic
progression. Given that n is a positive integer, the equation, x2 − y2 − z2 =
n, has exactly one solution when n = 20:

132 − 102 − 72 = 20

In fact there are twenty-five values of n below one hundred for which the
equation has a unique solution.

How many values of n less than fifty million have exactly one solution?

=head1 ANALYSIS

(z+2d)^2 - (z+d)^2 - z^2 = z^2+4dz+4d^2 - z^2 - 2dz - d^2 - z^2 =
-z^2 + 2dz +3d^2 = (-z + 3d)(z + d)

=cut

my $solution_counts_vec = '';
my $ten_counts = 0;

my $LIMIT = 50_000_000;

foreach my $z (1 .. ($LIMIT-1))
{
    print "Z = $z ; Ten Counts = $ten_counts\n" if ($z % 10_000 == 0);
    my $d = (int($z/3)+1);

    D_LOOP:
    while (1)
    {
        my $n = (3*$d-$z)*($z+$d);

        if ($n >= $LIMIT)
        {
            last D_LOOP;
        }
        elsif ($n > 0)
        {
            my $c = vec($solution_counts_vec, $n, 2);
            $c++;
            if ($c == 2)
            {
                $ten_counts--;
            }
            elsif ($c == 3)
            {
                # Make sure it doesn't overflow.
                $c--;
            }
            elsif ($c == 1)
            {
                $ten_counts++;
            }
            vec($solution_counts_vec, $n, 2) = $c;
        }
    }
    continue
    {
        $d++;
    }
}

print "Ten counts = $ten_counts\n";
