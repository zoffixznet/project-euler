#!/usr/bin/perl

use strict;
use warnings;

my $limit = 1_500_000;

my $verdicts = "";

my $hypotenuse_lim = int($limit/2);

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
                if (vec($verdicts, $sum, 2) != 2)
                {
                    vec($verdicts, $sum, 2)++;
                }
            }
        }
    }
}

my $count = 0;
foreach my $sum (12 .. $limit)
{
    if (vec($verdicts, $sum, 2) == 1)
    {
        $count++
    }
}

print "Count = $count\n";

