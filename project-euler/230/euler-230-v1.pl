#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw( firstidx );

STDOUT->autoflush(1);

my $A =
'1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679';
my $B =
'8214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196';

my @lens = ( 0 + length($A), 0 + length($B) );

sub f
{
    my ( $pos, $n ) = @_;

    if ( $pos <= 1 )
    {
        return substr( ( $pos ? $B : $A ), $n - 1, 1 );
    }
    elsif ( $n <= $lens[ $pos - 2 ] )
    {
        return f( $pos - 2, $n );
    }
    else
    {
        return f( $pos - 1, $n - $lens[ $pos - 2 ] );
    }
}

sub D
{
    my ($n) = @_;

    while ( $lens[-1] < $n )
    {
        push @lens, $lens[-1] + $lens[-2];
    }

    my $pos = firstidx { $_ >= $n } @lens;

    return f( $pos, $n );
}

for my $n ( reverse( 0 .. 17 ) )
{
    print D( ( 127 + 19 * $n ) * ( 7**$n ) );
}
print "\n";
