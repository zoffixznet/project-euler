#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use CalcRects;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $NUM_DIVS = 10;
my $MAX = 10_000 + 399;
my $DIV = (( $MAX ) / $NUM_DIVS + 1);

my @DIM_RANGES;

push @DIM_RANGES, [0, $DIV];
while ($DIM_RANGES[-1][-1] != $MAX)
{
    my $start = $DIM_RANGES[-1][-1]+1;
    my $end = min($start + $DIV, $MAX);
    push @DIM_RANGES, [$start, $end];
}

my $RECTS = CalcRects::calc_processed_rects();

if (my $filter = $ENV{COUNT})
{
    splice(@$RECTS, $filter);
}

my $total_count = 0;

sub rec
{
    my ($prev_coords, $remaining) = @_;

    if (@$prev_coords == 3)
    {
        my $v = '';

        my @dim_r =
        (
            map
            {
                my $i = $_->{dim_i};
                my $r = $DIM_RANGES[$i];
                [ $i, $r->[1]-$r->[0]+1, $r->[0],]
            }
            @$prev_coords
        );

        my $count = 0;
        foreach my $r (@$remaining)
        {
            my ($XX, $YY, $ZZ) =
            (map {
                    my $i = $_;
                    my $off = $dim_r[$i]->[2];
                    [map { $_-$off} @{$r->[$i]}]
                }
                keys(@$r)
            );
            my $y_delta = $dim_r[0]->[1];
            my $z_delta = $dim_r[1]->[1] * $y_delta;
            my $z_off = $z_delta * $ZZ->[0];
            for my $z ($ZZ->[0] .. $ZZ->[1])
            {
                my $y_off = $z_off + $YY->[0] * $y_delta;
                for my $y ($YY->[0] .. $YY->[1])
                {
                    my $x_off = $y_off + $XX->[0];
                    for my $x ($XX->[0] .. $XX->[1])
                    {
                        if (!vec($v, $x_off, 1))
                        {
                            $count++;
                        }
                        vec($v, $x_off, 1) = 1;
                    }
                    continue
                    {
                        $x_off++;
                    }
                }
                continue
                {
                    $y_off += $y_delta;
                }
            }
            continue
            {
                $z_off += $z_delta;
            }
        }

        $total_count += $count;
        print "Found Count = $count for (" . join(",", map {$_->{dim_i} } @$prev_coords) . ") for a total of TotalCount = $total_count\n"
    }
    else
    {
        my $dim = @$prev_coords;
        for my $dim_i (keys(@DIM_RANGES))
        {
            my $X_RANGE = $DIM_RANGES[$dim_i];

            my $NUM_X = $X_RANGE->[1]-$X_RANGE->[0]+1;

            my @rects;

            # Popoulate @rects.
            RECTS:
            foreach my $r (@$remaining)
            {
                my @p = @$r;
                my $s = max($X_RANGE->[0], $p[$dim][0]);
                my $e = min($X_RANGE->[1], $p[$dim][1]);

                if ($e < $s)
                {
                    next RECTS;
                }
                $p[$dim] = [$s,$e];
                push @rects, \@p;
            }

            rec([@$prev_coords, { dim_i => $dim_i, }], ( \@rects ));
        }
    }

    return;
}

rec([], $RECTS);
