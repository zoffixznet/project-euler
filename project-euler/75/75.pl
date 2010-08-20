#!/usr/bin/perl

use strict;
use warnings;

my $limit = 1_500_000;

my $verdicts = "";

my $hypotenuse_lim = int($limit/2);

HYPO:
for my $hypotenuse_length (5 .. $hypotenuse_lim)
{
    if ($hypotenuse_length & 0x1)
    {
        
    }

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

