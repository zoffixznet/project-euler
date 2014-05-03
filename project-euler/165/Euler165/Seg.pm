package Euler165::Seg;

use strict;
use warnings;

use Carp::Always;

use parent 'Exporter';

our $TYPE_X_ONLY = 0;
our $TYPE_XY = 1;

our @EXPORT_OK = qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect intersect_x);

sub gcd
{
    my ($n, $m) = @_;

    if ($m > $n)
    {
        ($n, $m) = ($m, $n);
    }

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}

sub signed_gcd
{
    my ($n, $m) = @_;

    return gcd(abs($n),abs($m));
}

sub _reduce
{
    my ($n,$d) = @_;

    my $g = signed_gcd($n,$d);

    my @ret = ($n / $g, $d / $g);

    if ($ret[0] == 0)
    {
        return (0,1);
    }
    elsif ($ret[1] < 0)
    {
        return map { -$_ } @ret;
    }
    else
    {
        return @ret;
    }
}

sub _mul
{
    my ($x, $y) = @_;

    return [_reduce($x->[0]*$y->[0],$x->[1]*$y->[1])];
}

sub _div
{
    my ($x, $y) = @_;

    return _mul($x, [$y->[1],$y->[0]]);
}

sub _add
{
    my ($x, $y) = @_;

    return [_reduce($x->[0]*$y->[1] + $x->[1]*$y->[0],$x->[1]*$y->[1])];
}

sub _subtract
{
    my ($x, $y) = @_;

    return _add($x, [(-$y->[0]),$y->[1]]);
}

sub _lt
{
    my ($x, $y) = @_;

    return (_subtract($x,$y)->[0] < 0);
}

sub _eq
{
    my ($x, $y) = @_;

    return (_subtract($x,$y)->[0] == 0);
}

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
        my $m = [_reduce($y2-$y1, $x2-$x1)];
        my $bb = _subtract([$y1,1], _mul($m, [$x1,1]));
        my @x_s = sort { $a <=> $b } ($x1,$x2);
        return {t => $TYPE_XY, m => $m, b => $bb, x1 => $x_s[0], x2 => $x_s[-1],};
    }
}

sub intersect_x
{
    my ($s1, $s2) = @_;
    my $x = [$s1->{'x'},1];

    my $y = _add(_mul($s2->{'m'},$x), $s2->{'b'});

    if (_lt([$s2->{'x1'},1], $x) and _lt($x, [$s2->{'x2'},1])
            and _lt([$s1->{'y1'},1], $y)
            and _lt($y, [$s1->{'y2'},1])
    )
    {
        return [$x, $y];
    }
    else
    {
        return undef;
    }
}

sub intersect
{
    my ($s1, $s2) = @_;

    # Both are y = f(x) so m1x+b1 == m2x+b2 ==> x
    if (_eq($s1->{'m'}, $s2->{'m'}))
    {
        return undef;
    }
    else
    {
        my $x = _div(_subtract($s2->{'b'}, $s1->{'b'}), _subtract($s1->{'m'}, $s2->{'m'}));

        if (_lt([$s1->{'x1'},1], $x) and _lt($x, [$s1->{'x2'},1]) and _lt([$s2->{'x1'}, 1], $x) and
            _lt($x, [$s2->{'x2'},1])
        )
        {
            return [$x, _add($s2->{'b'}, _mul($s2->{'m'}, $x))];
        }
        else
        {
            return undef;
        }
    }
}
