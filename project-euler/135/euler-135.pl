#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 DESCRIPTION

Given the positive integers, x, y, and z, are consecutive terms of an
arithmetic progression, the least value of the positive integer, n, for which
the equation, x2 − y2 − z2 = n, has exactly two solutions is n = 27:

342 − 272 − 202 = 122 − 92 − 62 = 27

It turns out that n = 1155 is the least value which has exactly ten solutions.

How many values of n less than one million have exactly ten distinct solutions?

=head1 ANALYSIS

(z+2d)^2 - (z+d)^2 - z^2 = z^2+4dz+4d^2 - z^2 - 2dz - d^2 - z^2 =
-z^2 + 2dz +3d^2 = (-z + 3d)(z + d)
=cut

my $solution_counts_vec = '';
my $ten_counts = 0;

my $z = 2;

my $LIMIT = 1_000_000;

for $z (1 .. $LIMIT)
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
            my $c = vec($solution_counts_vec, $n, 4);
            $c++;
            if ($c == 11)
            {
                $ten_counts--;
            }
            elsif ($c == 12)
            {
                # Make sure it doesn't overflow.
                $c--;
            }
            elsif ($c == 10)
            {
                $ten_counts++;
            }
            vec($solution_counts_vec, $n, 4) = $c;
        }
    }
    continue
    {
        $d++;
    }
}

print "Ten counts = $ten_counts\n";
