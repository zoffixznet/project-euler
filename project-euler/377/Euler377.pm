package Euler377;

use strict;
use warnings;

my %mult_cache;

sub calc_multiplier
{
    my ($n) = @_;

    return ($mult_cache{$n} = 200);
}

sub recurse_digits
{
    my ($n) = @_;

    calc_multiplier($n);

    return;
}

1;
