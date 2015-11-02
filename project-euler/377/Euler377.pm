package Euler377;

use strict;
use warnings;

use integer;
use bytes;

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

    my $digit_base = 0;

    return;
}

1;
