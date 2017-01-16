package Euler80;

use strict;
use warnings;

use Math::BigInt ( ":constant", lib => 'GMP' );

my $required_digits = 100;

my $margin                 = 10;
my $req_digits_with_margin = $required_digits + $margin;

sub square_root
{
    my $n = shift;

    my $n_with_digits = $n * ( 10**( $req_digits_with_margin * 2 ) );

    my $min = 0;
    my $max = $n_with_digits;
    my $mid = ( ( $max + $min ) >> 1 );

    my $epsilon = $n_with_digits / ( 10**$req_digits_with_margin );

    while (1)
    {
        my $square = $mid * $mid;

        # print "Mid = $mid\n";
        # print "Sq = $square\n";

        if ( abs( $square - $n_with_digits ) <= $epsilon )
        {
            return $mid;
        }
        elsif ( $square > $n_with_digits )
        {
            $max = $mid;
            $mid = ( ( $max + $min ) >> 1 );
        }
        else
        {
            $min = $mid;
            $mid = ( ( $max + $min ) >> 1 );
        }
    }
}

# print "Result == ", square_root(2), "\n";

1;

