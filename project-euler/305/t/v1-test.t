#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::Differences (qw( eq_or_diff ));

sub mytest
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($needle, $count, $blurb) = @_;

    return eq_or_diff(
        scalar(`perl euler-305-v1.pl $needle $count`),
        scalar(`bash good-results.bash $needle $count`),
        "$blurb - $needle $count",
    );
}

{
    # TEST
    mytest(1, 100, "Euler 305");
}

