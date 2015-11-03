#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use List::MoreUtils qw/all/;

use Euler377;

sub gen_id_mat
{
    return [
        map {
            my $i = $_;
            [map { (($_ == $i) ? 1 : 0); } @Euler377::DIGITS ]
        }
        @Euler377::DIGITS
    ];
}

{
    my $ID_MAT = gen_id_mat();
    my $result = Euler377::multiply(
        $ID_MAT,
        $ID_MAT,
    );

    # TEST
    ok(
        scalar
        (
        all
        {
            my $i = $_;
            all
            {
                my $j = $_;
                ($result->{normal}->[$i]->[$j] == (($i == $j) ? 1 : 0));
            }
            @Euler377::DIGITS;
        } @Euler377::DIGITS
    ),
        "id * id == id",
    );
}

{
    # TEST
    is (''.Euler377::calc_count(1), 1, "count(1) is correct.");

    # TEST
    is (''.Euler377::calc_count(2), 2, "count(2) is correct.");

    # TEST
    is (''.Euler377::calc_count(3), scalar(@{[
                    qw(
                    111
                    12
                    21
                    3
                    )
                ]}), "count(2) is correct.");

    # TEST
    is (''.Euler377::calc_count(5), 16, "count(5) is correct.");
}

{
    @Euler377::N_s = (13);
    # TEST
    is (
        Euler377::calc_result(),
        (Euler377::calc_using_brute_force(13) % 1_000_000_000),
        "Good calc_result for 13.",
    );
}

{
    Euler377::reset_caches();
    local $Euler377::BASE = 14;
    @Euler377::N_s = (14);
    # TEST
    is (
        Euler377::calc_result(),
        (Euler377::calc_using_brute_force(14) % 1_000_000_000),
        "Good calc_result for 14.",
    );
}
