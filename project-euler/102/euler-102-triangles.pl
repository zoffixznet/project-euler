#!/usr/bin/perl

use strict;
use warnings;

# We return the area multiplies by 2 for convenience.
sub triangle_area
{
    my ($xa, $ya, $xb, $yb, $xc, $yc) = @_;

    return abs( ($xa-$xc)*($yb-$ya) - ($xa-$xb)*($yc-$ya) );
}

my $count = 0;

open my $in, "<", "triangles.txt";
while (my $line = <$in>)
{
    chomp($line);

    my @coords = split(/,/, $line);

    my $main_area = triangle_area(@coords);

    my $sub_areas_total = 0;

    for my $point_to_zero (0 .. 2)
    {
        my @new_coords = @coords;
        # Set the other point to zero.
        $new_coords[$point_to_zero*2] = $new_coords[$point_to_zero*2+1] = 0;
        $sub_areas_total += triangle_area(@new_coords);
    }

    if ($sub_areas_total == $main_area)
    {
        $count++;
    }
}
close($in);

print "$count\n";
