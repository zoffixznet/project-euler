#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use lib '.';
use Euler435 ();

{
    my $n   = 7;
    my $x   = 11;
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

    use Data::Dumper;
    print Dumper(
        [ map { [ map "$_", @$_ ] } @{ $obj->calc_count_matrix(3)->{normal} } ]
    );

    # TEST
    is( $obj->calc_count( $x, $n ) . '', 268357683, "calc_count for $n" );
}

