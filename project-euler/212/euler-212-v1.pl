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

# my $NUM_DIVS = 10;
my $NUM_DIVS = 5;
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

        my $y_delta = $prev_coords->[0]->[1];
        my $z_delta = $prev_coords->[1]->[1] * $y_delta;

        my $count = 0;
        foreach my $r (@$remaining)
        {
            my ($XX, $YY, $ZZ) = @$r;

            my $z_end = $z_delta * $ZZ->[1];
            for (my $z = $z_delta * $ZZ->[0]; $z <= $z_end; $z += $z_delta)
            {
                my $y_end = $z + $YY->[1] * $y_delta;
                for (my $y = $z + $y_delta * $YY->[0]; $y <= $y_end; $y += $y_delta)
                {
                    for my $x (($y + $XX->[0]) .. ($y + $XX->[1]))
                    {
                        if (!vec($v, $x, 1))
                        {
                            $count++;
                        }
                        vec($v, $x, 1) = 1;
                    }
                }
            }
        }

        $total_count += $count;
        print "Found Count = $count for (" . join(",", map {$_->[0] } @$prev_coords) . ") for a total of TotalCount = $total_count\n"
    }
    else
    {
        my $dim = @$prev_coords;
        for my $dim_i (keys(@DIM_RANGES))
        {
            my $X_RANGE = $DIM_RANGES[$dim_i];

            my $NUM_X = $X_RANGE->[1]-$X_RANGE->[0]+1;

            my @rects;

            my $S = $X_RANGE->[0];
            my $E = $NUM_X - 1;

            # Popoulate @rects.
            RECTS:
            foreach my $r (@$remaining)
            {
                my @p = @$r;

                my $s = $p[$dim][0]-$S;
                if ($s > $E)
                {
                    next RECTS;
                }
                if ($s < 0)
                {
                    $s = 0;
                }

                my $e = $p[$dim][1]-$S;
                if ($e < 0)
                {
                    next RECTS;
                }
                if ($e > $E)
                {
                    $e = $E;
                }

                $p[$dim] = [$s,$e];
                push @rects, \@p;
            }

            rec([@$prev_coords, [$dim_i, $NUM_X]], ( \@rects ));
        }
    }

    return;
}

rec([], $RECTS);
