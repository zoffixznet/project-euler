#!/usr/bin/perl

use strict;
use warnings;

use Euler165::Seg qw(compile_segment intersect);
use Euler165::R;

my %points;

my $r = Euler165::R->new;

my @segs;

for my $n (1 .. 5000)
{
    push @segs, compile_segment($r->get_seg);
}

STDOUT->autoflush(1);

for my $first (keys(@segs))
{
    for my $second ($first+1 .. $#segs)
    {
        my $p = intersect(@segs[$first, $second]);
        if (defined $p)
        {
            $points{join("!", @$p)}++;
        }
    }
    print "Reached $first.\n";
}

print "Num intersections == ", scalar(keys%points), "\n";
