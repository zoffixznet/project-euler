#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

sub count
{
    my ( $tile_len, $total_len ) = @_;

    my @counts;

    foreach my $len ( 0 .. $tile_len - 1 )
    {
        push @counts, 1;
    }

    foreach my $len ( $tile_len .. $total_len )
    {
        push @counts, $counts[ -$tile_len ] + $counts[-1];
    }

    # We need to exclude the all-black-squares one which is:
    # 1. Common.
    # 2. Should not be included.
    return $counts[-1] - 1;
}

sub count_for_234
{
    my $total_len = shift;

    return count( 2, $total_len ) + count( 3, $total_len ) +
        count( 4, $total_len );
}

print count_for_234(50), "\n";
