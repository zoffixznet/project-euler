#!/usr/bin/perl

use strict;
use warnings;

use Euler165::Seg qw($TYPE_X_ONLY $TYPE_XY compile_segment intersect);
use Euler165::R;

STDOUT->autoflush(1);

my %points;

my $r = Euler165::R->new;

my (@x_segs, @xy_segs);

for my $n (1 .. 5000)
{
    print "N=$n\n";
    my $seg_points = $r->get_seg;
    my $seg = compile_segment($seg_points);

    if ($seg->{t} == $TYPE_X_ONLY)
    {
        push @x_segs, $seg;
    }
    else
    {
        push @xy_segs, $seg;
    }
}

@xy_segs = (sort { $a->{'x1'} <=> $b->{'x1'} or $a->{'x2'} <=> $b->{'x2'} } @xy_segs);

sub _check
{
    my ($s1, $s2) = @_;
    my $p = intersect($s1, $s2);
    if (defined $p)
    {
        $points{join("!",map { @$_ } @$p)} = undef();
    }
}

my $first = 0;
while ($first < @xy_segs)
{
    my $s1 = $xy_segs[$first];
    my $x1 = $s1->{'x1'};
    my $x2 = $s1->{'x2'};

    for my $s2 (@x_segs)
    {
        _check($s1, $s2);
    }
    I2:
    for my $i2 ($first+1 .. $#xy_segs)
    {
        my $s2 = $xy_segs[$i2];
        if ($s2->{'x1'} >= $x2)
        {
            last I2;
        }
        _check($s1,$s2);
    }
    print "Reached $first/$#xy_segs.\n";
    $first++;
}

print "Num intersections == ", scalar(keys%points), "\n";
