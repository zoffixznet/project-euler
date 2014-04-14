#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Test::More tests => 9;

sub calc_f_delta
{
    my ($exp) = @_;

    return ($exp+1) * (10 ** $exp);
}

sub calc_f_delta_for_leading_digits
{
    my ($num_digits_after, $num_leading_d_digits) = @_;

    return $num_leading_d_digits * 10 ** $num_digits_after + (($num_digits_after-1 >= 0) ? calc_f_delta($num_digits_after-1) : 0);
}

sub f_d_n
{
    my ($d, $n) = @_;

    my @digits = split(//, ($n+1).'');

    my $ret = 0;

    my $num_leading_d_digits = 0;

    foreach my $place (reverse(keys @digits))
    {
        my $place_d = $digits[$place];

        for my $iter_d (0 .. $place_d-1)
        {
            if ($iter_d != $d)
            {
                $ret += calc_f_delta_for_leading_digits($place, $num_leading_d_digits);
            }
            else
            {
                $ret += calc_f_delta_for_leading_digits($place, $num_leading_d_digits+1);
            }
        }
        if ($place_d == $d)
        {
            $num_leading_d_digits++;
        }
    }

    return $ret;
}

# TEST
is (
    calc_f_delta(0),
    1,
    "calc_f_delta(0)",
);

# TEST
is (
    calc_f_delta(1),
    20,
    "calc_f_delta(1)",
);

# TEST
is (
    calc_f_delta(2),
    300,
    "calc_f_delta(2)",
);

# TEST
is (
    calc_f_delta(8),
    900000000,
    "calc_f_delta(8)",
);

# TEST
is (
    calc_f_delta_for_leading_digits(1, 0),
    1,
    "calc_f_delta_for_leading_digits(1,0)",
);

# TEST
is (
    calc_f_delta_for_leading_digits(2, 0),
    20,
    "calc_f_delta_for_leading_digits(2,0)",
);

# TEST
is (
    calc_f_delta_for_leading_digits(1, 1),
    11,
    "calc_f_delta_for_leading_digits(1,1)",
);

# TEST
is (
    calc_f_delta_for_leading_digits(1, 2),
    21,
    "calc_f_delta_for_leading_digits(1,2)",
);

# TEST
is (
    f_d_n(1, 1),
    1,
    "f_d_n(1,1)",
);
