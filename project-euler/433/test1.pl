#!/usr/bin/perl

use strict;
use warnings;

STDOUT->autoflush(1);
for my $MAX ( 3 .. 1_000_000 )
{
    print "$MAX\n";
    for my $AA ( 2 .. $MAX )
    {
        foreach my $x ( 2 .. $MAX )
        {
            foreach my $y ( 1 .. $x - 1 )
            {
                if ( $AA * ( $x % $y ) != ( $AA * $x ) % ( $AA * $y ) )
                {
                    die "$AA $x $y!";
                }
            }
        }
    }
}
