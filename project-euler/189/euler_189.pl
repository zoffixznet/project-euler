#!/usr/bin/perl

use strict;
use warnings;

use bytes;
use integer;

use List::Util qw(sum);
use List::MoreUtils qw();

my @by_height;

sub init_by_height
{
    @by_height = ();

    $by_height[0] =
    {
        seq => { '' => 1, },
        derived =>
        {
            '' =>
            {
                '0' => 1,
                '1' => 1,
                '2' => 1,
            }
        },
    };
    $by_height[1] =
    {
        seq => {'0' => 1, '1' => 1, '2' => 1,},
        count => 3,
    };

    return;
}

init_by_height();

sub my_find
{
    my ($wanted_h) = @_;

    for my $h (1 .. $wanted_h-1)
    {
        # Now $by_height[$h-1]{seq} is ready.
        my $this_seq = $by_height[$h]{seq};
        my $prev_derived = $by_height[$h-1]{derived};

        my $count = 0;
        my $next_derived = {};
        my $next_seq = {};

        $by_height[$h+1]{seq} = $next_seq;
        $by_height[$h+1]{count} = $count;
        $by_height[$h]{derived} = $next_derived;
    }

    return $by_height[$wanted_h]{count};
}
