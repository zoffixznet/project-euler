package CalcRects;

use strict;
use warnings;

use Rand;

sub calc_rects
{
    my $r = Rand->new;

    my @rects;

    for my $n (1 .. 50_000)
    {
        my @myrect;

        for my $i (1 .. 3)
        {
            push @myrect, $r->get() % 10_000;
        }
        for my $i (1 .. 3)
        {
            push @myrect, (1 + ($r->get() % 399));
        }

        push @rects, \@myrect;
    }

    return \@rects;
}

1;

