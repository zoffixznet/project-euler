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

foreach my $y ( 0 .. $lim )
{
    $matrix[$y][0]->{sum} = $matrix[$y][0]->{v};
}

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

    push @sums, $matrix[$y][ $x - 1 ]->{sum} + $matrix[$y][$x]->{v};

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

for my $x ( 1 .. $lim )
{
    print "Reached $x\n";
    my $changed = 1;
    while ($changed)
    {
        $changed = 0;

        for my $y ( 0 .. $lim )
        {
            $changed ||= calc_sum( $y, $x );
        }
    }
}

print "Sum = ", min( map { $matrix[$_][$lim]->{sum} } ( 0 .. $lim ) ), "\n";
