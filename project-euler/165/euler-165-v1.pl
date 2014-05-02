#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(any);

use bigrat;

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

@xy_segs = (sort { $a->{'m'} <=> $b->{'m'} } @xy_segs);

my $first = 0;
while ($first < @xy_segs)
{
    my $s1 = $xy_segs[$first];
    my $m = $s1->{'m'};

    my $i = $first+1;

    while ($i < @xy_segs and $xy_segs[$i]->{'m'} == $i)
    {
        $i++;
    }

    for my $s1_1 (@xy_segs[$first .. $i-1])
    {
        for my $s2 (@x_segs, @xy_segs[$i .. $#xy_segs])
        {
            # print "Subreached $first->$second.\n";
            my $p = intersect($s1_1, $s2);
            if (defined $p)
            {
                $points{join("!",@$p)} = undef();
            }
        }
    }
    $first = $i;
    print "Reached $first/$#xy_segs.\n";
}

print "Num intersections == ", scalar(keys%points), "\n";
