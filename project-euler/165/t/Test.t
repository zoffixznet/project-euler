#!/usr/bin/perl

use strict;
use warnings;

use Euler165::R;

use Test::More tests => 2;

use Test::Differences qw(eq_or_diff);

my $TYPE_X_ONLY = 0;
my $TYPE_XY = 1;

sub compile_segment
{
    my ($L) = @_;

    my ($x1, $y1, $x2, $y2) = @$L;

    if ($x1 == $x2)
    {
        if ($y1 == $y2)
        {
            die "Duplicate point in segment [@$L].";
        }
        return {t => $TYPE_X_ONLY, x => $x1};
    }
    else
    {
        my $m = ($y2-$y1)/($x2-$x1);
        my $b = ($y1 - $m * $x1);
        return {t => $TYPE_XY, m => $m, b => $b, x1 => $x1, x2 => $x2,};
    }
}

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
        { t => $TYPE_X_ONLY, x => 0, },
        "TYPE_X_ONLY",
    );
}
