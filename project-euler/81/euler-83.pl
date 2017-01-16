#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min);

use IO::All;

my @lines = io("matrix.txt")->chomp->getlines();

my @matrix = (
    map {
        [ map { +{ v => $_ } } ( split( /,/, $_ ) ) ]
    } @lines
);

my $size = 80;
my $lim  = $size - 1;

$matrix[0][0]->{sum} = $matrix[0][0]->{v};

sub calc_sum
{
    my ( $y, $x ) = @_;

    my @sums;

    if ( $y > 0 && exists( $matrix[ $y - 1 ][$x]->{sum} ) )
    {
        push @sums, $matrix[ $y - 1 ][$x]->{sum} + $matrix[$y][$x]->{v};
    }

    if ( $y < $lim && exists( $matrix[ $y + 1 ][$x]->{sum} ) )
    {
        push @sums, $matrix[ $y + 1 ][$x]->{sum} + $matrix[$y][$x]->{v};
    }

    if ( $x > 0 && exists( $matrix[$y][ $x - 1 ]->{sum} ) )
    {
        push @sums, $matrix[$y][ $x - 1 ]->{sum} + $matrix[$y][$x]->{v};
    }

    if ( $x < $lim && exists( $matrix[$y][ $x + 1 ]->{sum} ) )
    {
        push @sums, $matrix[$y][ $x + 1 ]->{sum} + $matrix[$y][$x]->{v};
    }

    if ( !@sums )
    {
        return;
    }

    my $min = min(@sums);

    if (   ( !exists( $matrix[$y][$x]->{sum} ) )
        || ( $min < $matrix[$y][$x]->{sum} ) )
    {
        $matrix[$y][$x]->{sum} = $min;
        return 1;
    }
    else
    {
        return;
    }
}

my $changed  = 1;
my $iter_num = 0;
while ($changed)
{
    $changed = 0;

    for my $y ( 0 .. $lim )
    {
        for my $x ( 0 .. $lim )
        {
            if ( calc_sum( $y, $x ) )
            {
                $changed = 1;
                print "Modify $y,$x\n";
            }
        }
    }
}
continue
{
    print "Iter = ", $iter_num++, "\n";
}

print "Sum = ", $matrix[$lim][$lim]->{sum}, "\n";
