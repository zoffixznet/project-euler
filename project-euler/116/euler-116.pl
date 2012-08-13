#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

A row of five black square tiles is to have a number of its tiles replaced with
coloured oblong tiles chosen from red (length two), green (length three), or
blue (length four).

If red tiles are chosen there are exactly seven ways this can be done.

If green tiles are chosen there are three ways.

And if blue tiles are chosen there are two ways.

Assuming that colours cannot be mixed there are 7 + 3 + 2 = 12 ways of
replacing the black tiles in a row measuring five units in length.

How many different ways can the black tiles in a row measuring fifty units in
length be replaced if colours cannot be mixed and at least one coloured tile
must be used?

NOTE: This is related to problem 117.

=cut

use Math::GMP qw(:constant);

sub count
{
    my ($tile_len, $total_len) = @_;

    my @counts;

    foreach my $len (0 .. $tile_len-1)
    {
        push @counts, 1;
    }

    for my $len ($tile_len .. $total_len)
    {
        push @counts, $counts[-$tile_len]+$counts[-1];
    }

    # We need to exclude the all-black-squares one which is:
    # 1. Common.
    # 2. Should not be included.
    return $counts[-1]-1;
}

sub count_for_234
{
    my $total_len = shift;

    return count(2, $total_len) + count(3, $total_len) + count(4, $total_len);
}

print count_for_234(50), "\n";
