#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(reduce);

sub find_cycle
{
    my $n = shift;

    my %states;

    my $r = 1;
    my $count;
    while ( !exists( $states{"$r"} ) )
    {
        $states{"$r"} = $count++;
        $r = +( $r * 10 ) % $n;
    }
    return $count - $states{"$r"};
}

my $pair =
    reduce { $a->[1] > $b->[1] ? $a : $b }
map { [ $_, find_cycle($_) ] } ( 2 .. 999 );

print join( ",", @$pair ), "\n";
