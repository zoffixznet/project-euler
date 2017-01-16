#!/usr/bin/perl

use strict;
use warnings;

=head1 Keywords

Pythagoras, Euler's Formula, Hypoteneuse

=cut

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m == 0 )
    {
        return $n;
    }

    return gcd( $m, $n % $m );
}

my $limit      = 100_000_000;
my $half_limit = ( $limit >> 1 );

my $hypotenuse_lim = int( $limit / 2 );

my $major_side_limit = int( $limit / 2 );

# Euclid's formula
my $m_limit = int( sqrt($hypotenuse_lim) );

my $count = 0;

for my $m ( 2 .. $m_limit )
{
    if ( $m % 1000 == 0 )
    {
        print "M=$m\n";
    }
    my $n = ( ( ( $m & 0x1 ) == 0 ) ? 1 : 2 );

N_LOOP:
    while ( $n < $m )
    {
        if ( gcd( $m, $n ) == 1 )
        {
            my $half_sum = $m * ( $m + $n );
            if ( $half_sum > $half_limit )
            {
                last N_LOOP;
            }

            my ( $aa, $bb, $cc ) =
                ( $m * $m - $n * $n, 2 * $m * $n, $m * $m + $n * $n );

            if ( $cc % abs( $bb - $aa ) == 0 )
            {
                $count += int( $half_limit / $half_sum );
            }
        }
    }
    continue
    {
        $n += 2;
    }
}

print "Count = $count\n";

