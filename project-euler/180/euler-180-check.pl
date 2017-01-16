#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub check
{
    my ( $n, $x, $y, $z ) = ( map { Math::BigInt->new("$_") } @_ );

    if ( $x**( $n + 1 ) +
        $y**( $n + 1 ) -
        $z**( $n + 1 ) +
        ( $x * $y + $y * $z + $z * $x ) *
        ( $x**( $n - 1 ) + $y**( $n - 1 ) - $z**( $n - 1 ) ) -
        $x * $y * $z *
        ( $x**( $n - 2 ) + $y**( $n - 2 ) - $z**( $n - 2 ) ) !=
        ( ( $x + $y + $z ) * ( $x**$n + $y**$n - $z**$n ) ) )
    {
        print "$x,$y,$z\[n=$n] Mismatch.\n";
        die "Foo";
    }

    return;
}

for my $z ( 1 .. 100 )
{
    for my $x ( 1 .. $z )
    {
        for my $y ( 1 .. $x )
        {
            for my $n ( 3 .. 10 )
            {
                print "Checking $x,$y,$z,$n\n";
                check( $n, $x, $y, $z );
            }
        }
    }
}
