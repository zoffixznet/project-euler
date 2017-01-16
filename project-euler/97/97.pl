#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Math::BigInt only => 'GMP';

my $modulo = Math::BigInt->new("10000000000");

sub get_power_modulo
{
    my ( $b, $e ) = @_;

    if ( $e == 0 )
    {
        return 1;
    }

    my $rec_p = get_power_modulo( $b, ( $e >> 1 ) );

    my $ret = $rec_p * $rec_p;

    if ( $e & 0x1 )
    {
        $ret *= $b;
    }

    return ( $ret % $modulo );
}

# TEST
is( get_power_modulo( 2, 5 ) . "", 32, "2 ** 5 is right." );

# TEST
is( get_power_modulo( 3, 3 ) . "", 27, "3 ** 3 is right." );

# TEST
is( get_power_modulo( 2, 10 ) . "", 1024, "2 ** 1024 is right." );

print "Answer = ",
    ( ( get_power_modulo( 2, 7830457 ) * 28433 + 1 ) % $modulo ), "\n";

=head1 Documentation

The first known prime found to exceed one million digits was discovered in 1999, and is a Mersenne prime of the form 2^(6972593)−1; it contains exactly 2,098,960 digits. Subsequently other Mersenne primes, of the form 2^(p)−1, have been found which contain more digits.

However, in 2004 there was found a massive non-Mersenne prime which contains 2,357,207 digits: 28433×2^(7830457)+1.

Find the last ten digits of this prime number.

=cut

