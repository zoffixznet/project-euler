#!/usr/bin/perl

use strict;
use warnings;

sub is_prime
{
    my ($n) = @_;

    if ( $n <= 1 )
    {
        return 0;
    }

    my $top = int( sqrt($n) );

    for my $i ( 2 .. $top )
    {
        if ( $n % $i == 0 )
        {
            return 0;
        }
    }

    return 1;
}

my ( $max_a, $max_b, $max_iter );

$max_iter = 0;
for my $b_coeff ( 0 .. 999 )
{
    for my $a_coeff ( ( -$b_coeff + 1 ) .. 999 )
    {
        my $n = 0;
        while ( is_prime( $b_coeff + $n * ( $n + $a_coeff ) ) )
        {
            $n++;
        }
        $n--;
        if ( $n > $max_iter )
        {
            ( $max_a, $max_b, $max_iter ) = ( $a_coeff, $b_coeff, $n );
        }
    }
}
printf( "a = %d ; b = %d ; n = %d\n", ( $max_a, $max_b, $max_iter ) );

