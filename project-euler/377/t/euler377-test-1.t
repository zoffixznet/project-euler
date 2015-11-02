#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use Euler377;

{
    local $Euler377::BASE = 14;
    @Euler377::N_s = (14);
    # TEST
    is (
        Euler377::calc_result(),
        (Euler377::calc_using_brute_force(14) % 1_000_000_000),
        "Good calc_result for 14.",
    );
}
