#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use List::Util qw(min max sum);
use List::MoreUtils qw();

use IO::All qw/io/;
use JSON::MaybeXS qw(decode_json encode_json);

use CalcRects;

# use Math::BigInt lib => 'GMP', ':constant';

STDOUT->autoflush(1);

# Octet set-bits counts.
my @O_C;
{
    for my $from (0 .. 0xFFFF)
    {
        my $bit_count = sub {
            my $binary = sprintf("%b", shift);
            return $binary =~ tr/1/1/;
        };
        $O_C[$from] = $bit_count->($from);
    }
}

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

my $RECTS_FN = 'rects_cache.json';
if (! -e $RECTS_FN)
{
    io->file($RECTS_FN)->print(encode_json(CalcRects::calc_processed_rects()));
}

my $RECTS = decode_json(io->file($RECTS_FN)->all);

if (my $filter = $ENV{COUNT})
{
    splice(@$RECTS, $filter);
}

my $total_count = 0;

my @XEs = (map { ((1 << (1+($_ & 0xF)))- 1) } 0 .. 0xF);
my @XSs = (map {  (0xFFFF ^ ((1 << ($_ & 0xF))-1)) } 0 .. 0xF);

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
                    # print ":COUNT:=@$XX,@$YY,@$ZZ => $count\n";
                    my $x_start = ($y + $XX->[0]);
                    my $x_end = ($y + $XX->[1]);

                    my $byte_start = ($x_start >> 4);
                    my $byte_end = ($x_end >> 4);
                    if ($byte_start == $byte_end)
                    {
                        my $val = vec($v, $byte_start, 16);
                        $count += $O_C[
                            vec($v, $byte_start, 16) = ($val | (((1 << ($x_end-$x_start+1))-1) << ($x_start & 0xF)))
                        ] - $O_C[$val];
                    }
                    else
                    {
                        {
                            my $val = vec($v, $byte_start, 16);
                            $count += $O_C[
                                vec($v, $byte_start, 16) = ($val | $XSs[$x_start & 0xF])
                            ] - $O_C[$val];
                        }
                        # This is a funky way to do $count += 16 - $O_C[byte]
                        # for every byte, where 16 is the number of bit counts.
                        for my $x ($byte_start + 1 .. $byte_end - 1)
                        {
                            $count -= $O_C[vec($v,$x,16)];
                            vec($v,$x,16) = 0xFFFF;
                        }
                        if ((my $n = ($byte_end - $byte_start - 1)) > 0)
                        {
                            $count += ($n << 4);
                        }
                        {
                            my $val = vec($v, $byte_end, 16);
                            $count += $O_C[vec($v, $byte_end, 16) = ($val | $XEs[$x_end & 0xF])] - $O_C[$val];
                        }
                    }
                    # print ":COUNT:=@$XX,@$YY,@$ZZ => $count\n";
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
        # for my $dim_i ($dim == 0 ? 1 : 4)
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
