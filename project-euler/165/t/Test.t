#!/usr/bin/perl

use strict;
use warnings;

use Euler165::R;

use Test::More tests => 6;

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
        my @y_s = sort {$a <=> $b} ($y1,$y2);
        return {t => $TYPE_X_ONLY, x => $x1, y1=>$y_s[0], y2=>$y_s[-1],};
    }
    else
    {
        my $m = ($y2-$y1)/($x2-$x1);
        my $bb = ($y1 - $m * $x1);
        my @x_s = sort { $a <=> $b } ($x1,$x2);
        return {t => $TYPE_XY, m => $m, b => $bb, x1 => $x_s[0], x2 => $x_s[-1],};
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
        { t => $TYPE_X_ONLY, x => 0, y1 => 1, y2 => 2,},
        "TYPE_X_ONLY",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,0,1,1]),
        { t => $TYPE_XY, m => 1, b => 0, x1 => 0, x2 => 1,},
        "TYPE_XY_ONLY #1",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([0,0,100,0]),
        { t => $TYPE_XY, m => 0, b => 0, x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - 0 slope.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([-5,0,5,0]),
        { t => $TYPE_XY, m => 0, b => 0, x1 => -5, x2 => 5,},
        "TYPE_XY_ONLY #2 - 0 slope.",
    );
}

{
    # TEST
    eq_or_diff(
        compile_segment([100,3,0,3]),
        { t => $TYPE_XY, m => 0, b => 3, x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - reversed Xs - should be sorted.",
    );
}
