#!/usr/bin/perl

use strict;
use warnings;

my $n          = 1;
my $expected_n = 0;
my $exp        = 0.5;
my $prev_prob  = 0;

while (1)
{
    my $next_prob = ( 1 - $exp )**32;
    $expected_n += $n * ( $next_prob - $prev_prob );
    $prev_prob = $next_prob;
    printf "Exp[n] = %.10f\n", $expected_n;
}
continue
{
    $n++;
    $exp *= 0.5;
}
