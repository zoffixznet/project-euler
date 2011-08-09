#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

It turns out that 12 cm is the smallest length of wire that can be bent to form an integer sided right angle triangle in exactly one way, but there are many more examples.

12 cm: (3,4,5)
24 cm: (6,8,10)
30 cm: (5,12,13)
36 cm: (9,12,15)
40 cm: (8,15,17)
48 cm: (12,16,20)

In contrast, some lengths of wire, like 20 cm, cannot be bent to form an integer sided right angle triangle, and other lengths allow more than one solution to be found; for example, using 120 cm it is possible to form exactly three different integer sided right angle triangles.

120 cm: (30,40,50), (20,48,52), (24,45,51)

Given that L is the length of the wire, for how many values of L ≤ 1,500,000 can exactly one integer sided right angle triangle be formed?

Note: This problem has been changed recently, please check that you are using the right parameters.

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

my $limit = 1_500_000;
my $half_limit = ($limit >> 1);

my $verdicts = "";

my $hypotenuse_lim = int($limit/2);

my $major_side_limit = int($limit/2);

MAJOR_SIDE:
for my $major_side (4 .. $major_side_limit)
{
    if ($major_side % 100 == 0)
    {
        print "Maj=$major_side\n";
    }
    MINOR_SIDE:
    for my $minor_side (3 .. ($major_side - 1))
    {
        if (gcd( $major_side , $minor_side ) != 1)
        {
            next MINOR_SIDE;
        }

        my $hypot_sq = $major_side * $major_side + $minor_side * $minor_side;

        my $hypot = sqrt($hypot_sq);
        if ($hypot == int($hypot))
        {
            # Only even numbers can be sums, so we can divide the index
            # by 2.
            # See 75-analysis.txt
            my $sum = (($major_side + $minor_side + $hypot) >> 1);
            
            if ($sum > $half_limit)
            {
                last MINOR_SIDE;
            }

            if (vec($verdicts, $sum, 2) != 2)
            {
                my $sum_product = 0;

                while (($sum_product += $sum) < $half_limit)
                {
                    if (vec($verdicts, $sum_product, 2) != 2)
                    {
                        vec($verdicts, $sum_product, 2)++;
                    }
                }
            }
        }
    }
}

my $count = 0;
foreach my $sum_idx ((12>>1) .. ($limit>>1))
{
    if (vec($verdicts, $sum_idx, 2) == 1)
    {
        $count++
    }
}

print "Count = $count\n";

