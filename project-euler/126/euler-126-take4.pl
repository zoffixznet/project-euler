#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

use integer;

STDOUT->autoflush(1);

my @C;

# Used to be:
# <<<
# Matches $X,$Y,$Z (where $X >= $Y >= $Z) to the cuboid array and maximal 
# reached layer.
# >>>
# Now we no longer need the $X,$Y,$Z.
#
# Since the counts are divisible by 2 and are kept multiplied by 2, we
# keep their halfs.

my $max_C_n = 0;

my $LIMIT = 50_000;

my $z = 1;

Z_LOOP:
while (1)
{
    print "Checking z=$z\n";
    Y_LOOP:
    for my $y (1 .. $z)
    {
        X_LOOP:
        for my $x (1 .. $y)
        {
            my $new_layer_count = 
                ($x*($y+$z)+$z*$y);

            my $delta = ((($x+$y+$z)<<1)-4);

            if ($new_layer_count >= $LIMIT)
            {
                if ($x == 1)
                {
                    if ($y == 1)
                    {
                        last Z_LOOP;
                    }
                    else
                    {

                        last Y_LOOP;
                    }
                }
                else
                {
                    last X_LOOP;
                }
            }
            while ($new_layer_count < $LIMIT)
            {
                $C[$new_layer_count]++;
                $new_layer_count += ($delta += 4);
            }
        }
    }
}
continue
{
    $z++;
}

foreach my $count (1 .. $#C)
{
    if (defined($C[$count]))
    {
        print "C[" , ($count*2), "] = $C[$count]\n";
    }
}
