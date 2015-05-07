#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Euler215 qw(from_id to_id);

use Test::Differences (qw( eq_or_diff ));

{
    my $wall = [
        { l => 8, o => 3, },
        { l => 7, o => 3, },
        { l => 6, o => 2, },
    ];

    # TEST
    eq_or_diff(
        from_id(to_id($wall)),
        $wall,
        "Back and forth from_id/to_id",
    );
}

