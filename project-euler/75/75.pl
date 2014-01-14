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

my $limit = 1_500_000;

my $verdicts = "";

my $hypotenuse_lim = int($limit/2);

HYPO:
for my $hypotenuse_length (5 .. $hypotenuse_lim)
{
    print "$hypotenuse_length\n" if (not $hypotenuse_length % 1_000);
    my $hypot_sq = $hypotenuse_length ** 2;

    my $side1_lim = int($hypotenuse_length / 2);

    for my $side1_len (1 .. $side1_lim)
    {
        my $side2_len = sqrt($hypot_sq - ($side1_len ** 2));

        if ($side2_len == int($side2_len))
        {
            my $sum = int($side2_len+$side1_len+$hypotenuse_length);
            if ($sum <= $limit)
            {
                # Only even numbers can be sums, so we can divide the index
                # by 2.
                # See 75-analysis.txt
                my $idx = ($sum>>1);
                if (vec($verdicts, $idx, 2) != 2)
                {
                    vec($verdicts, $idx, 2)++;
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

