#!/usr/bin/perl

use strict;
use warnings;

use 5.014;

=head1 DESCRIPTION

In a 3x2 cross-hatched grid, a total of 37 different rectangles could be
situated within that grid as indicated in the sketch.

There are 5 grids smaller than 3x2, vertical and horizontal dimensions being
important, i.e. 1x1, 2x1, 3x1, 1x2 and 2x2. If each of them is cross-hatched,
the following number of different rectangles could be situated within those
smaller grids:

1x1: 1 2x1: 4 3x1: 8 1x2: 4 2x2: 18

Adding those to the 37 of the 3x2 grid, a total of 72 different rectangles
could be situated within 3x2 and smaller grids.

How many different rectangles could be situated within 47x43 and smaller grids?

=cut

# A 4-dimensional cache:
# 0 - board large dim.
# 1 - board small dim.
# 2 - rect large dim.
# 3 - rect large dim.
# Each value is:
# {
my @Cache;

sub get_unique_rects
{
    # $x >= $y >= $rect_x , $rect_y
    my ($x, $y, $rect_x, $rect_y) = @_;

    my $struct = ($Cache[$x][$y][$rect_x][$rect_y] //= {});

    # No longer needed because calculated directly in get_total_rects()
    # my $unique_num_straight = ($x-$rect_x+1) * ($y-$rect_y+1);
    # $struct->{unique_num_straight} = $unique_num_straight;
    #



    return $struct;
}

sub get_total_rects
{
    my ($x, $y) = @_;

    my $sum = 0;

    foreach my $xx (1 .. $x)
    {
        foreach my $yy (1 .. $y)
        {
            $sum += $xx * $yy * ($x - $xx + 1) * ($y - $yy + 1);
        }
    }

    return {num_straight_rects => $sum};
}

my ($x, $y) = @ARGV;

# my $num_rects = get_rects(47, 43, 47, 43);
my $num_straight_rects = get_total_rects($x, $y)->{num_straight_rects};

print "Straight Rects = $num_straight_rects\n";


