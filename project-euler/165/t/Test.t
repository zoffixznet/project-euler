#!/usr/bin/perl

use strict;
use warnings;

use Euler165::R;

use Test::More tests => 11;

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

sub intersect
{
    my ($s1, $s2) = @_;

    ($s1, $s2) = sort { $a->{'t'} <=> $b->{'t'} } ($s1, $s2);

    if ($s1->{'t'} == $TYPE_X_ONLY)
    {
        if ($s2->{'t'} == $TYPE_X_ONLY)
        {
            return undef;
        }
        else
        {
            my $x = ($s1->{'x'});

            my $y = ($s2->{'m'} * $x + $s2->{'b'});

            if ($s2->{'x1'} < $x and $x < $s2->{'x2'} and
                $s1->{'y1'} < $y and $y < $s1->{'y2'}
            )
            {
                return [$x, $y];
            }
            else
            {
                return undef;
            }
        }
    }
    else
    {
        # Both are y = f(x) so m1x+b1 == m2x+b2 ==> x
        if ($s1->{'m'} == $s2->{'m'})
        {
            return undef;
        }
        else
        {
            my $x = (($s2->{'b'} - $s1->{'b'}) / ($s1->{'m'} - $s2->{'m'}));

            if ($s1->{'x1'} < $x and $x < $s1->{'x2'} and $s2->{'x1'} < $x and
                $x < $s2->{'x2'}
            )
            {
                return [$x, $s2->{'m'} * $x + $s2->{'b'}];
            }
            else
            {
                return undef;
            }
        }
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
        compile_segment([0,50,0,0]),
        { t => $TYPE_X_ONLY, x => 0, y1 => 0, y2 => 50,},
        "TYPE_X_ONLY - reversed y extents.",
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

{
    # TEST
    eq_or_diff(
        compile_segment([100,2*100+5,0,0+5,]),
        { t => $TYPE_XY, m => 2, b => 5, x1 => 0, x2 => 100,},
        "TYPE_XY_ONLY #2 - slope - reversed Xs - should be sorted.",
    );
}

{
    my $r = intersect(compile_segment([46,53,17,62]),compile_segment([46,70,22,40]));

    my $EPSILON = 0.001;
    # TEST
    ok (
        scalar(abs($r->[0] - 35.1049723) <= $EPSILON),
        "X for intersect."
    );

    # TEST
    ok (
        scalar(abs($r->[1] - 56.381215) <= $EPSILON),
        "Y for intersect."
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
