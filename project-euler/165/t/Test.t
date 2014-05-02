#!/usr/bin/perl

use strict;
use warnings;

use Euler165::R;

use Euler165::Seg qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect);

use Test::More tests => 12;

use Test::Differences qw(eq_or_diff);


{
    my $obj = Euler165::R->new;

    # TEST
    eq_or_diff(
        $obj->get_seg,
        [27, 144, 12, 232],
        "First segment",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,1,0,2]),
        { t => $TYPE_X_ONLY, x => 0, y1 => 1, y2 => 2,},
        "TYPE_X_ONLY",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,50,0,0]),
        { t => $TYPE_X_ONLY, x => 0, y1 => 0, y2 => 50,},
        "TYPE_X_ONLY - reversed y extents.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,0,1,1]),
        { t => $TYPE_XY, m => [1,1], b => [0,1], x1 => 0, x2 => 1,},
        "TYPE_XY_ONLY #1",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,0,100,0]),
        { t => $TYPE_XY, m => [0,1], b => [0,1], x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - 0 slope.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([-5,0,5,0]),
        { t => $TYPE_XY, m => [0,1], b => [0,1], x1 => -5, x2 => 5,},
        "TYPE_XY_ONLY #2 - 0 slope.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([100,3,0,3]),
        { t => $TYPE_XY, m => [0,1], b => [3,1], x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - reversed Xs - should be sorted.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([100,2*100+5,0,0+5,]),
        { t => $TYPE_XY, m => [2,1], b => [5,1], x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - slope - reversed Xs - should be sorted.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,100,50,100+50/5,]),
        { t => $TYPE_XY, m => [1,5], b => [100,1], x1 => 0, x2 => 50,},
        "TYPE_XY #2 - slope - ",
    );
}

{
    # TEST
    eq_or_diff(
        intersect(compile_segment([46,53,17,62]),compile_segment([46,70,22,40])),
        [[6354,181,],[10205,181,],],
        "Interesct L2 and L3",
    );
}

{
    # TEST
    eq_or_diff(
        intersect(compile_segment([46,53,17,62]),compile_segment([27,44,12,32])),
        undef,
        "Intersect L2 and L1",
    );
}

{
    # TEST
    eq_or_diff(
        intersect(compile_segment([46, 70, 22, 40]),compile_segment([27,44,12,32])),
        undef,
        "Intersect L1 and L3",
    );
}
