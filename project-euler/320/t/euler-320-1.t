#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Euler320 qw(factorial_factor_exp);

{
    # TEST
    is (
        factorial_factor_exp(5, 5),
        1,
        "5,5 ==> 1",
    );

    # TEST
    is (
        factorial_factor_exp(10, 5),
        2,
        "10,5 ==> 2",
    );
}

