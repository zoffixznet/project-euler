package Euler377;

use strict;
use warnings;

use integer;
use bytes;

my %mult_cache;

sub calc_multiplier
{
    my ($sum) = @_;

    return ($mult_cache{$sum} = sub {
            return 200;
    }->());
}

sub recurse_digits
{
    my ($sum) = @_;

    calc_multiplier($sum);

    my $digit_base = 0;

    return;
}

1;
