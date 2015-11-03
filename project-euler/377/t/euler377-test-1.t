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
    is (''.Euler377->new->calc_count(1), 1, "count(1) is correct.");

    # TEST
    is (''.Euler377->new->calc_count(2), 2, "count(2) is correct.");

    # TEST
    is (''.Euler377->new->calc_count(3), scalar(@{[
                    qw(
                    111
                    12
                    21
                    3
                    )
                ]}), "count(2) is correct.");

    # TEST
    is (''.Euler377->new->calc_count(5), 16, "count(5) is correct.");
}

sub test_single_calc_result
{
    my ($BASE, $blurb) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return is (
        Euler377->new({BASE => $BASE, N_s => [$BASE]})->calc_result(),
        (Euler377->new({BASE => $BASE, N_s => [$BASE]})->calc_using_brute_force($BASE) % 1_000_000_000),
        $blurb,
    );
}

{
    # TEST
    test_single_calc_result(13, "Good calc result for 13");

    # TEST
    test_single_calc_result(14, "Good calc result for 14");
}
