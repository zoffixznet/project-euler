#!/usr/bin/perl

use strict;
use warnings;

my %counts = ( 4 => [], 6 => [] );
my %totals = ( 4 => 0, 6 => 0 );

sub recurse
{
    my ( $num_sides, $sum_so_far, $remaining_dice ) = @_;

    if ( $remaining_dice == 0 )
    {
        $counts{$num_sides}[$sum_so_far]++;
        $totals{$num_sides}++;
    }
    else
    {
        for my $i ( 1 .. $num_sides )
        {
            recurse( $num_sides, $sum_so_far + $i, $remaining_dice - 1 );
        }
    }
    return;
}

recurse( 4, 0, 9 );
recurse( 6, 0, 6 );

my $OTHER      = 6;
my $other_sums = [];
{
    my $s = 0;
    push @$other_sums, $s;
    foreach my $count ( @{ $counts{$OTHER} } )
    {
        push @$other_sums, ( $s += ( $count // 0 ) );
    }
}

my $PIVOT = 4;

my $pivot_counts = $counts{$PIVOT};

my $prob_sum = 0;
foreach my $score ( keys(@$pivot_counts) )
{
    my $prob = ( $pivot_counts->[$score] // 0 );
    if ( $prob > 0 )
    {
        $prob_sum += $prob * ( $other_sums->[$score] );
    }
}

printf "ProbSum = %i ; Prob = %.7f\n", $prob_sum,
    ( $prob_sum / ( $totals{$PIVOT} * $totals{$OTHER} ) );
