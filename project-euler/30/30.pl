#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

my @D_POWERS;
foreach my $d ( 0 .. 9 )
{
    my $e = 1;
    foreach my $p ( 1 .. 5 )
    {
        $e *= $d;
    }
    push @D_POWERS, $e;
}

my $n = 9;

my $sum        = 0;
my $STEP       = 1_000_000;
my $checkpoint = $STEP;
while (1)
{
    if ( ++$n == $checkpoint )
    {
        print "Reached n=$n ; sum = $sum\n";
        $checkpoint += $STEP;
    }
    if ( sum( @D_POWERS[ split //, $n ] ) == $n )
    {
        $sum += $n;
        print "$n : sum = $sum\n";
    }
}
