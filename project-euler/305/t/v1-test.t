#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 19;

use Test::Differences (qw( eq_or_diff ));

my $which = $ENV{'WHICH_CMD'};

my $CMD = ($which eq '1' ? 'perl euler-305-v1.pl' :
    $which eq '2' ? './e305-debug.exe' :
    $which eq '3' ? './e305-prod.exe' :
    (die "Unknown WHICH_CMD")
);

sub mytest
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($needle, $count, $blurb) = @_;

    return eq_or_diff(
        scalar(`$CMD $needle $count`),
        scalar(`bash good-results.bash $needle $count`),
        "$blurb - $needle $count",
    );
}

{
    # TEST
    mytest(1, 100, "Euler 305");

    # TEST
    mytest(2, 100, "Euler 305");

    # TEST
    mytest(3, 100, "Euler 305");

    # TEST
    mytest(10, 100, "Euler 305");

    # TEST
    mytest(11, 100, "Euler 305");

    # TEST
    mytest(9, 100, "Euler 305");

    # TEST
    mytest(100, 100, "Euler 305");

    # TEST
    mytest(101, 20, "Euler 305");

    # TEST
    mytest(102, 20, "Euler 305");

    # TEST
    mytest(91, 100, "Euler 305");

    # TEST
    mytest(90, 100, "Euler 305 - do not halt on 90");

    # TEST
    mytest(99, 100, "Euler 305");

    # TEST
    mytest(891, 100, "Euler 305");

    # TEST
    mytest(910, 100, "Euler 305");

    # TEST
    mytest(911, 100, "Euler 305");

    # TEST
    mytest(1011, 100, "Euler 305");

    # TEST
    mytest(303, 100, "Euler 305");

    # TEST
    mytest(1912, 100, "Euler 305");

    # TEST
    mytest(243, 100, "Euler 305");
}

