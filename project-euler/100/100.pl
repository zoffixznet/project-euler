#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

use Math::BigInt lib => "GMP", ":constant";

my $n      = 7;
my $prev_n = 1;

STDOUT->autoflush(1);

sub find_blue_discs_num
{
    my $num_discs = shift;

    my $bottom = ( $num_discs >> 1 );
    my $top    = $num_discs;

    my $divide_by = $num_discs * ( $num_discs - 1 );

    my $wanted_product = ( $divide_by >> 1 );

    while ( $top >= $bottom )
    {
        my $mid = ( ( $bottom + $top ) >> 1 );

        my $product = $mid * ( $mid - 1 );
        if ( $product == $wanted_product )
        {
            return $mid;
        }
        elsif ( $product < $wanted_product )
        {
            $bottom = $mid + 1;
        }
        else
        {
            $top = $mid - 1;
        }
    }
    return;
}

while (1)
{
    if ( $n > 1_000_000_000_000 )
    {
        my $m = ( ( $n + 1 ) / 2 );
        print "P(BB)[$m] = ", find_blue_discs_num($m), "\n";
    }
}
continue
{
    ( $n, $prev_n ) = ( 6 * $n - $prev_n, $n );
}
