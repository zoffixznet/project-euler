#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Euler320 qw(factorial_factor_exp);

{
    # TEST
    is (
        factorial_factor_exp(5, 5),
        1,
        "5,5 ==> 1",
    );
}

