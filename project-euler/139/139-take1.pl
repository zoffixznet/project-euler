#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Let (a, b, c) represent the three sides of a right angle triangle with integral length sides. It is possible to place four such triangles together to form a square with length c.

For example, (3, 4, 5) triangles can be placed together to form a 5 by 5 square with a 1 by 1 hole in the middle and it can be seen that the 5 by 5 square can be tiled with twenty-five 1 by 1 squares.

However, if (5, 12, 13) triangles were used then the hole would measure 7 by 7 and these could not be used to tile the 13 by 13 square.

Given that the perimeter of the right triangle is less than one-hundred million, how many Pythagorean triangles would allow such a tiling to take place?
=cut

=head1 Keywords

Pythagoras, Euler's Formula, Hypoteneuse

=cut

sub gcd
{
    my ($n, $m) = @_;

    if ($m == 0)
    {
        return $n;
    }

    return gcd($m,$n % $m);
}

my $limit = 100_000_000;
my $half_limit = ($limit >> 1);

my $hypotenuse_lim = int($limit/2);

my $major_side_limit = int($limit/2);

# Euclid's formula
my $m_limit = int(sqrt($hypotenuse_lim));

my $count = 0;

for my $m (2 .. $m_limit)
{
    if ($m % 1000 == 0)
    {
        print "M=$m\n";
    }
    my $n = ((($m & 0x1) == 0) ? 1 : 2);

    N_LOOP:
    while ($n < $m)
    {
        if (gcd( $m, $n ) == 1)
        {
            my $half_sum = $m * ($m + $n);
            if ($half_sum > $half_limit)
            {
                last N_LOOP;
            }

            my ($aa, $bb, $cc) = ($m*$m-$n*$n, 2*$m*$n, $m*$m+$n*$n);

            if ($cc % abs($bb-$aa) == 0)
            {
                $count += int( $half_limit / $half_sum );
            }
        }
    }
    continue
    {
        $n += 2;
    }
}

print "Count = $count\n";

