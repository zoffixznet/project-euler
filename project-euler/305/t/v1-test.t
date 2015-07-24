#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::Differences (qw( eq_or_diff ));

{
    # TEST
    eq_or_diff(
        scalar(`perl euler-305-v1.pl 1 100`),
        scalar(`bash good-results.bash 1 100`),
        "Testing Euler305 - 1 100",
    );
}

