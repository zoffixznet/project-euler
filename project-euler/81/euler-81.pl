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

    if ( $y > 0 )
    {
        push @sums, $matrix[ $y - 1 ][$x]->{sum} + $matrix[$y][$x]->{v};
    }

    if ( $x > 0 )
    {
        push @sums, $matrix[$y][ $x - 1 ]->{sum} + $matrix[$y][$x]->{v};
    }

    $matrix[$y][$x]->{sum} = min(@sums);

    return;
}

for my $depth ( 1 .. $lim )
{
    for my $y ( 0 .. $depth )
    {
        my $x = $depth - $y;
        calc_sum( $y, $x );
    }
}

for my $depth ( ( $lim + 1 ) .. ( 2 * $lim ) )
{
    for my $y ( ( $depth - $lim ) .. $lim )
    {
        my $x = $depth - $y;
        calc_sum( $y, $x );
    }
}

print "Sum = ", $matrix[$lim][$lim]->{sum}, "\n";
