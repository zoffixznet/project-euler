#!/usr/bin/perl

use strict;
use warnings;

for my $base ( 3 .. 100 )
{
    print "Base: $base\n------------------\n\n";
    my $max = $base - 1;

    my @mods = map { ( ( $_ * ( 3 * $_ - 1 ) ) % $base ) } ( 0 .. $max );
    my %e = ( map { $_ => 1 } @mods );

    # print map { sprintf ("%-5d%-5d\n", $_, $modulos[$_]); } (0 .. $max);
    # print "\n";

    for my $m ( 0 .. $max )
    {
        my $found = 0;
        my @skips;
        for my $d ( 0 .. $max )
        {
            if (   !exists( $e{ ( $mods[$m] + $mods[$d] ) % $base } )
                || !exists( $e{ ( $mods[$m] * 2 + $mods[$d] ) % $base } ) )
            {
                push @skips, "SKIP : D = $d ; Min = $m\n";
            }
            else
            {
                $found = 1;
            }
        }
        if ( !$found )
        {
            print "MMMSKIP : M = $m\n";
        }
        else
        {
            print @skips;
        }
    }
    print "\n";
}
