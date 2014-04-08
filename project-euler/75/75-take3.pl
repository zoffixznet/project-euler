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

# Euclid's formula
my $m_limit = int(sqrt($hypotenuse_lim));
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

            if (vec($verdicts, $half_sum, 2) != 2)
            {
                my $sum_product = 0;

                while (($sum_product += $half_sum) < $half_limit)
                {
                    if (vec($verdicts, $sum_product, 2) != 2)
                    {
                        vec($verdicts, $sum_product, 2)++;
                    }
                }
            }
        }
    }
    continue
    {
        $n += 2;
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

