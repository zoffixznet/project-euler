#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Test::More tests => 13;

use Euler156_V2 qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

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

# TEST
is (
    f_d_n(1, 2),
    1,
    "f_d_n(1,2)",
);

# TEST
is (
    f_d_n(1, 10),
    2,
    "f_d_n(1, 10)",
);

# TEST
is (
    f_d_n(1, 11),
    4,
    "f_d_n(1, 11)",
);

# TEST
is (
    f_d_n(1, 12),
    5,
    "f_d_n(1, 12)",
);
