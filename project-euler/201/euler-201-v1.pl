#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub solve_for_set
{
    my ($set_ref, $num_elems) = @_;

    my @set = @$set_ref;

    my @sums = (0);
    foreach my $x (@set)
    {
        push @sums, $sums[-1] + $x;
    }

    my $top_sum = sub {
        my ($c) = @_;
        return $sums[-1] - $sums[-($c+1)];
    };

    my $bottom_sum = sub {
        my ($start, $c) = @_;

        return $sums[$start+$c] - $sums[$start];
    };

    # Recurse;
    my $r;
    # Number of solutions.
    my $num_sols;

    $r = sub {
        # $init_s is initial start.
        my ($num_remain, $goal, $init_s) = @_;

        {
            my $ts = $top_sum->($num_remain);
            if ($ts == $goal)
            {
                $num_sols++;
                return;
            }
            elsif ($ts < $goal)
            {
                return;
            }
        }
        for my $s ($init_s .. $num_elems - $num_remain - 1)
        {
            {
                my $bs = $bottom_sum->($s, $num_remain);
                if ($bs == $goal)
                {
                    $num_sols++;
                    return;
                }
                elsif ($bs > $goal)
                {
                    return;
                }
            }
            $r->($num_remain-1, $goal-$set[$s], $s+1);
            if ($num_sols == 2)
            {
                return;
            }
        }
    };

    my $total_sum = 0;

    for my $partial_sum ($bottom_sum->(0, $num_elems) .. $top_sum->($num_elems))
    {
        $num_sols = 0;
        $r->($num_elems, $partial_sum, 0);

        if ($num_sols == 1)
        {
            $total_sum += $partial_sum;
        }
    }

    return $total_sum;
}

print solve_for_set([1, 3, 6, 8, 10, 11], 3), "\n";
