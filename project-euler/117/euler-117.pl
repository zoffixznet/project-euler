#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Using a combination of black square tiles and oblong tiles chosen from: red tiles measuring two units, green tiles measuring three units, and blue tiles measuring four units, it is possible to tile a row measuring five units in length in exactly fifteen different ways.

How many ways can a row measuring fifty units in length be tiled?

NOTE: This is related to problem 116.

=cut

use Math::GMP qw(:constant);

sub count
{
    my ($min_tile_len, $max_tile_len, $total_len) = @_;

    my @counts;

    foreach my $len (0 .. $min_tile_len-1)
    {
        push @counts, 1;
    }

    for my $len ($min_tile_len .. $total_len)
    {
        my $sum = 0;

        foreach my $delta (1, ($min_tile_len .. $max_tile_len))
        {
            if ($delta <= @counts)
            {
                $sum += $counts[-$delta];
            }
        }
        push @counts, $sum;
    }

    # We need to exclude the all-black-squares one which is:
    # 1. Common.
    # 2. Should not be included.
    return $counts[-1];
}

print count(2, 4, 50), "\n";
