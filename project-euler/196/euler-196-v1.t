#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use Test::More tests => 18;

use Row;

# TEST
is( Row->new( { idx => 1 } )->start(), 1, "Row[1].start" );

# TEST
is( Row->new( { idx => 2 } )->start(), 2, "Row[2].start" );

# TEST
is( Row->new( { idx => 3 } )->start(), 4, "Row[3].start" );

# TEST
is( Row->new( { idx => 4 } )->start(), 7, "Row[4].start" );

# TEST
is( Row->new( { idx => 1 } )->end(), 1, "Row[1].end" );

# TEST
is( Row->new( { idx => 2 } )->end(), 3, "Row[2].end" );

# TEST
is( Row->new( { idx => 3 } )->end(), 6, "Row[3].end" );

# TEST
is( Row->new( { idx => 4 } )->end(), 10, "Row[4].end" );

{
    my $row = Row->new( { idx => 4 } );

    $row->mark_primes;

    # TEST
    ok( scalar( $row->is_prime(0) ), "Row[4].is_prime(0)" );

    # TEST
    ok( scalar( !$row->is_prime(1) ), "! Row[4].is_prime(1)" );

    # TEST
    ok( scalar( !$row->is_prime(2) ), "! Row[4].is_prime(2)" );
}

{
    my $row = Row->new( { idx => 8 } );

    $row->mark_primes;

    # TEST
    ok( scalar( $row->is_prime(0) ), "Row[8].is_prime(0)" );

    # TEST
    ok( scalar( !$row->is_prime(1) ), "! Row[8].is_prime(1)" );

    # TEST
    ok( scalar( $row->is_prime(2) ), "Row[8].is_prime(2)" );
}

{
    my $row = Row->new( { idx => 3 } );

    $row->mark_primes;

    # TEST
    is( $row->calc_S(), 5, "Row[3].S()" );
}

{
    my $row = Row->new( { idx => 8 } );

    $row->mark_primes;

    # TEST
    is( $row->calc_S(), 60, "Row[8].S()" );
}

{
    my $row = Row->new( { idx => 9 } );

    $row->mark_primes;

    # TEST
    is( $row->calc_S(), 37, "Row[9].S()" );
}

{
    my $row = Row->new( { idx => 10_000 } );

    $row->mark_primes;

    # TEST
    is( $row->calc_S(), 950007619, "Row[10,000].S()" );
}
