#!/usr/bin/perl

use strict;
use warnings;

use integer;

my @C;

# Matches $X,$Y,$Z (where $X >= $Y >= $Z) to the cuboid array and maximal 
# reached layer.
my %cuboids;

my $max_layer_size = 1;

while (1)
{
    for my $z (1 .. $max_layer_size)
    {
        Y_LOOP:
        for my $y ($z .. $max_layer_size/$z)
        {
            my $x = $max_layer_size/$z/$y;

            if ($x * $y * $z != $max_layer_size 
                    or
                $x < $y)
            {
                next Y_LOOP;
            }

            print "$x,$y,$z\n";
        }
    }
}
continue
{
    $max_layer_size++;
}
