#!/usr/bin/perl

use strict;
use warnings;

sub pent
{
    my $x = shift;

    return ( ( $x * ( 3 * $x - 1 ) ) >> 1 );
}

sub is_pent
{
    my $x = shift;

    my $f = ( .5 + sqrt( .25 + 6 * $x ) ) / 3;
    return ( $f == int($f) );
}

for my $i ( 1 .. 3000 )
{
    for my $j ( $i + 1 .. 3000 )
    {
        if ( is_pent( pent($j) - pent($i) ) && is_pent( pent($j) + pent($i) ) )
        {
            print "answer = ", pent($j) - pent($i), "\n";
            exit(0);
        }
    }
}
