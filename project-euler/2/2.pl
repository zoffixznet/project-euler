#!/usr/bin/perl

use strict;
use warnings;

my ( $i, $j ) = ( 1, 2 );

my $sum;
while ( $i < 1e6 )
{
    if ( $i % 2 == 0 )
    {
        $sum += $i;
    }
}
continue
{
    ( $i, $j ) = ( $j, $i + $j );
}
print "$sum\n";
