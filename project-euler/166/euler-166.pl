#!/usr/bin/perl

use strict;
use warnings;

use List::MoreUtils qw(all indexes any true);
use List::Util qw(first sum max min);

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
            [grep { any { $_ == $cell } @$_ } @sums]
        }
        (0 .. (4*4-1))
    );

my $sum;

sub cell_loop
{
    my ($cell, $state, $callback) = @_;

    if (defined ($state->[$cell]))
    {
        $callback->($state);
        return;
    }

    my $call_v = sub {
        my ($val) = @_;

        $callback->(
            [map { ($_ == $cell) ? $val : $state->[$_] } keys(@$state)]
        );

        return;
    };

    my @sorted = (reverse sort { ($a->[0] <=> $b->[0]) }
        map
        {
            my $s = $_;
            [
                scalar(
               true { defined($_) } @$state[@$s]
            ),
            (sum(grep { defined($_) } @$state[@$s]) // 0),
            [grep { !defined($state->[$_]) } @$s],
            $_
            ]
        }
        @{$reverse_cell_lookup[$cell]}
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
    my @also_assign;
    while ($idx < @sorted)
    {
        my $remaining_sum = $sum-$sorted[$idx][1];
        my $num_remaining = (4-$sorted[$idx][0]);

        if (($remaining_sum < 0) or ($remaining_sum > (9 * $num_remaining)))
        {
            return;
        }

        if ($num_remaining == 2)
        {
            push @also_assign, [
                (first { $_ != $cell } @{$sorted[$idx][2]}),
                $remaining_sum,
            ];
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
        my @new_state = @$state;
        $new_state[$cell] = $v;
        foreach my $x (@also_assign)
        {
            $new_state[$x->[0]] = $x->[1]-$v;
        }
        $callback->( \@new_state );
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

sub wrapper
{
    my ($idx, $state) = @_;

    if ($idx == @$state)
    {
        if (all { sum(@$state[@$_]) == $sum } @sums)
        {
            $count++;
        }
        return;
    }

    cell_loop(
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
