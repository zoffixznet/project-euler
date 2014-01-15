#!/usr/bin/perl

use strict;
use warnings;

use bytes;
use integer;

use feature qw/say/;

my %colors = ('00' => [1,2], '11' => [0,2], '22' => [0,1],
    '01' => [2], '10' => [2],
    '02' => [1], '20' => [1],
    '12' => [0], '21' => [0],
);

my @l_colors = ([1,2], [0,2], [0,1]);

sub my_find
{
    my ($wanted_h) = @_;

    # The start_data for $h == 1
    my $data = {
        seq => {'0' => 1, '1' => 1, '2' => 1,},
        derived =>
        {
            '' =>
            {
                '0' => 1,
                '1' => 1,
                '2' => 1,
            }
        },
        count => 3,
    };
    for my $h (1 .. $wanted_h-1)
    {
        # Now $by_height[$h-1]{seq} is ready.
        my $this_seqs = $data->{seq};
        my $prev_deriveds = $data->{derived};

        my $total_count = 0;
        my $next_deriveds = {};
        my $next_seqs = {};

        while (my ($seq, $seq_count) = each %$this_seqs)
        {
            while (my ($left, $left_count) = each %{
                    $prev_deriveds->{substr($seq, 0, -1)} // {}
                }
            )
            {
                my $delta = $seq_count * $left_count;
                foreach my $lefter_tri_color (@{$colors{substr($seq,-1).substr($left, -1)}})
                {
                    foreach my $leftest_color (@{$l_colors[$lefter_tri_color]})
                    {
                        my $str = $left.$leftest_color;

                        $total_count += $delta;
                        $next_seqs->{$str} += $delta;
                        # $next_deriveds->{$seq}{$str} += $delta;
                        $next_deriveds->{$seq}{$str} += $left_count;
                    }
                }
            }
        }

        # Fill the next data.
        $data =
        {
            seq => $next_seqs,
            derived => $next_deriveds,
            count => $total_count,
        };
        say "Count[@{[$h+1]}] = $total_count";
    }

    return $data->{count};
}

# Test
{
    say my_find(2), " should be 3*2*2*2 == 24";
}
say "Result[8] = ", my_find(8);

