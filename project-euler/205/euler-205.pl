#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Dice Game

Peter has nine four-sided (pyramidal) dice, each with faces numbered 1, 2, 3,
4.
Colin has six six-sided (cubic) dice, each with faces numbered 1, 2, 3, 4, 5,
6.

Peter and Colin roll their dice and compare totals: the highest total wins. The
result is a draw if the totals are equal.

What is the probability that Pyramidal Pete beats Cubic Colin? Give your answer
rounded to seven decimal places in the form 0.abcdefg

=cut

my %counts = (4 => [], 6 => []);
my %totals = (4 => 0, 6 => 0);

sub recurse
{
    my ($num_sides, $sum_so_far, $remaining_dice) = @_;

    if ($remaining_dice == 0)
    {
        $counts{$num_sides}[$sum_so_far]++;
        $totals{$num_sides}++;
    }
    else
    {
        for my $i (1 .. $num_sides)
        {
            recurse($num_sides, $sum_so_far+$i, $remaining_dice-1);
        }
    }
    return;
}

recurse(4, 0, 9);
recurse(6, 0, 6);

my %running_sums = (4 => [0], 6 => [0]);

foreach my $num_sides (4, 6)
{
    my $sum_aref = $running_sums{$num_sides};
    foreach my $count (@{$counts{$num_sides}})
    {
        push @$sum_aref, ($sum_aref->[-1] + ($count // 0));
    }
}

use Data::Dumper;

print Dumper(\%running_sums);
