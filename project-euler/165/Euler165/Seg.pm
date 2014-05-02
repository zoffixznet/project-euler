package Euler165::Seg;

use strict;
use warnings;

use parent 'Exporter';

our $TYPE_X_ONLY = 0;
our $TYPE_XY = 1;

our @EXPORT_OK = qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect);


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
