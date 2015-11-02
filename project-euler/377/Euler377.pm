package Euler377;

use strict;
use warnings;

use integer;
use bytes;

our $BASE = 13;

my %mult_cache;

sub calc_multiplier
{
    my ($sum) = @_;

    return ($mult_cache{$sum} //= sub {
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

sub calc_result_above
{
    foreach my $new_digit (1 .. 2)
    {
        recurse_digits(
            $new_digit,
        );
    }
}

calc_result_above();

1;
