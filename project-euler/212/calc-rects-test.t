use strict;
use warnings;

use Test::More tests => 2;

use Test::Differences (qw( eq_or_diff ));

use CalcRects;

{
    my $rects = CalcRects::calc_rects();

    # TEST
    eq_or_diff(
        $rects->[0],
        [7,53,183,94,369,56],
        "Rect No. 0",
    );

    # TEST
    eq_or_diff(
        $rects->[1],
        [2383,3563,5079,42,212,344],
        "Rect No. 0",
    );
}
