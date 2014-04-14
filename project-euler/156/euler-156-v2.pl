#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Test::More tests => 8;

sub calc_f_delta
{
    my ($exp) = @_;

    return ($exp+1) * (10 ** $exp);
}

sub calc_f_delta_for_leading_digits
{
    my ($num_digits_after, $num_leading_d_digits) = @_;

    return $num_leading_d_digits * 10 ** $num_digits_after + calc_f_delta($num_digits_after-1);
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
