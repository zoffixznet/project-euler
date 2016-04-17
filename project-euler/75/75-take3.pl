#!/usr/bin/perl

use strict;
use warnings;

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

