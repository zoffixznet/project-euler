#!/usr/bin/perl

use strict;
use warnings;

use 5.018;

sub _calc
{
    my ($i) = @_;

    my $n = $i;
    my $s = sqrt(5);

    my $A = +( 1 + $s ) / 2;
    my $B = +( 1 - $s ) / 2;

    return $A**$n * ( 4 / $s * $A + 1 / $s ) +
        $B**$n * ( -4 * $B / $s - 1 / $s );
}

say _calc( shift(@ARGV) );
