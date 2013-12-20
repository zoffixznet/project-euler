#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(indexes any true);
use List::Util qw(sum max min);

my @sums =
(
    (map { my $r = $_; [map { $r*4+$_ } 0 .. 3] } (0 .. 3)),
    (map { my $c = $_; [map { $c+4*$_ } 0 .. 3] } (0 .. 3)),
    [map { $_+4*$_ } 0 .. 3],
    [map { ((4-1-$_)+4*$_) } 0 .. 3],
);

my @reverse_cell_lookup =
    (
        map
        {
            my $cell = $_;
            [indexes { any { $_ == $cell } @$_ } @sums]
        }
        (0 .. (4*4-1))
    );

sub cell_loop
{
    my ($sum, $cell, $state, $callback) = @_;

    my $call_v = sub {
        my ($val) = @_;

        $callback->(
            [map { ($_ == $cell) ? $val : $state->[$_] } keys(@$state)]
        );

        return;
    };

    my @cell_sums = @sums[@{$reverse_cell_lookup[$cell]}];

    my @sorted = (reverse sort { ($a->[0] <=> $b->[0]) }
        map
        {
            my $s = $_;
            [
                scalar(
               true { defined($_) } @$s
            ),
            sum(grep { defined($_) } @$s),
            $_
            ]
        }
        @cell_sums
    );

    my $val;

    my $idx = 0;

    while ($idx < @sorted and $sorted[$idx][0] == 3)
    {
        my $new_val = $sum - $sorted[$idx][1];
        if (!defined($val))
        {
            if (not ( ($new_val >= 0) and ($new_val <= 9)))
            {
                return;
            }
            $val = $new_val;
        }
        else
        {
            if ($new_val != $val)
            {
                return;
            }
        }
    }
    continue
    {
        $idx++;
    }

    if (defined($val))
    {
        $call_v->($val);

        return;
    }

    my $min_val = 0;
    my $max_val = 9;
    while ($idx < @sorted)
    {
        my $remaining_sum = $sum-$sorted[$idx][1];
        my $num_remaining = (4-$sorted[$idx][0]);

        if (($remaining_sum < 0) or ($remaining_sum > (9 * $num_remaining)))
        {
            return;
        }

        my $new_min_val = $remaining_sum - 9 * ($num_remaining - 1);
        my $new_max_val = $remaining_sum;

        $min_val = max($min_val, $new_min_val);
        $max_val = min($max_val, $new_max_val);
    }
    continue
    {
        $idx++;
    }

    foreach my $v ($min_val .. $max_val)
    {
        $call_v->($v);
    }

    return;
}

my @cells = (map { $_->[0]*4+$_->[1] }
    (
        [0,0],[1,1],[2,2],[3,3],
        [1,2],[2,1],[0,3],[3,0],
        [0,1],[0,2],
        [3,1],[3,2],
        [1,0],[2,0],
        [1,3],[2,3],
    )
);

my $count = 0;
my $sum;

sub wrapper
{
    my ($idx, $state) = @_;

    if ($idx == @$state)
    {
        $count++;
        return;
    }

    cell_loop(
        $sum,
        $cells[$idx],
        $state,
        sub {
            my ($new_state) = @_;
            return wrapper($idx+1, $new_state);
        },
    );
}

my $init_state = [map { undef } (0 .. 15)];
foreach my $sum_to_assign ((0*4) .. (9*4))
{
    $sum = $sum_to_assign;
    wrapper(0, $init_state);
    print "After Sum=$sum Count=$count\n";
}
