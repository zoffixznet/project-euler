#!/usr/bin/perl

use strict;
use warnings;
use autodie;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw(any none);

STDOUT->autoflush(1);

my $prod = 1;

my @primes;

open( my $list_fh, "primes 2|" );

P:
while ( my $p = <$list_fh> )
{
    chomp($p);
    $p = 0 + $p;
    push @primes, $p;
    $prod *= $p;

    my @modulos;

    for my $mod ( 0 .. $prod - 1 )
    {
        my $sq_mod = $mod * $mod;
        if (
            none
            {
                my $p = $_;
                any { ( $sq_mod + $_ ) % $p == 0 } ( 1, 3, 7, 9, 13, 27 )
            }
            @primes
            )
        {
            push @modulos, $mod;
        }
    }

    print "For $prod: "
        . sprintf( "%.100f", ( ( @modulos + 0.0 ) / $prod ) )
        . "[@modulos]\n";

    if ( $prod > 9_000_000 )
    {
        last P;
    }
}
