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

=cut

my $solution_counts_vec = '';
my $ten_counts = 0;

my $z_plus_d = 2;

my $LIMIT = 1_000_000;

my $all_are_over_a_million = 0;
while (! $all_are_over_a_million)
{
    $all_are_over_a_million = 1;
    print "Y = $z_plus_d ; Ten Counts = $ten_counts\n";
    D_LOOP:
    foreach my $d (1 .. $z_plus_d-1)
    {
        my $z = $z_plus_d - $d;
        my $y = $z_plus_d;
        my $x = $y + $d;

        my $n = $x*$x-$y*$y-$z*$z;
        if ($n < $LIMIT)
        {
            $all_are_over_a_million = 0;
            if ($n > 0)
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
        else
        {
            # n is monotonically increasing as a function of $d with constant
            # $y.
            last D_LOOP;
        }
    }
}
continue
{
    $z_plus_d++;
}
