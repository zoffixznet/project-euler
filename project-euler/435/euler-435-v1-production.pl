#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use Euler435 ();

{
    my $n   = Math::GMP->new( '1' . '0' x 15 );
    my $sum = 0;
    foreach my $x ( 1 .. 100 )
    {
        my $obj = Euler435->new(
            {
                calc_1_matrix => sub {
                    my $matrix1   = Euler435::gen_empty_matrix();
                    my $matrix1_t = Euler435::gen_empty_matrix();

                    my $assign = sub {
                        return Euler435::assign( $matrix1, $matrix1_t, @_ );
                    };

                    $assign->( 0, 0, 1 );
                    $assign->( 0, 1, 1 );
                    $assign->( 1, 2, 1 );
                    $assign->( 2, 1, $x * $x );
                    $assign->( 2, 2, $x );
                    return { normal => $matrix1, transpose => $matrix1_t, };

                }
            }
        );

        $sum += $obj->calc_count( $x, $n );
    }
    print "Result = ", $sum % $Euler435::MOD, "\n";
}

