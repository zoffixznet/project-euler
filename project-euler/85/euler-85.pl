#!/usr/bin/perl

use strict;
use warnings;

sub get_num_inner_rectangles
{
    my ($w, $h) = @_;

    my $sum = 0;
    for my $x (1 .. $w)
    {
        for my $y (1 .. $h)
        {
            $sum += ($w-$x+1)*($h-$y+1);
        }
    }

    return $sum;
}

print get_num_inner_rectangles(3,2), "\n";

my $min_w = 3;
my $min_h = 2;
my $min_num = get_num_inner_rectangles($min_w, $min_h);

W:
for my $w (2 .. 2_000_000)
{
    for my $h (1 .. $w)
    {
        my $num = get_num_inner_rectangles($w, $h);

        if (abs(2_000_000-$num) < abs(2_000_000 - $min_num))
        {
            $min_w = $w;
            $min_h = $h;
            $min_num = $num;
            print "Found $min_w,$min_h, @{[$min_w*$min_h]}\n"
        }
        elsif ($num > 2_000_000 and $h == 1)
        {
            last W;
        }
    }
}
