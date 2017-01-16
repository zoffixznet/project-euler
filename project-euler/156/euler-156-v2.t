#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Test::More tests => 9015;

use Euler156_V2 qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

# TEST
is( calc_f_delta(0), 1, "calc_f_delta(0)", );

# TEST
is( calc_f_delta(1), 20, "calc_f_delta(1)", );

# TEST
is( calc_f_delta(2), 300, "calc_f_delta(2)", );

# TEST
is( calc_f_delta(8), 900000000, "calc_f_delta(8)", );

# TEST
is(
    calc_f_delta_for_leading_digits( 1, 0 ),
    1, "calc_f_delta_for_leading_digits(1,0)",
);

# TEST
is(
    calc_f_delta_for_leading_digits( 2, 0 ),
    20, "calc_f_delta_for_leading_digits(2,0)",
);

# TEST
is(
    calc_f_delta_for_leading_digits( 1, 1 ),
    11, "calc_f_delta_for_leading_digits(1,1)",
);

# TEST
is(
    calc_f_delta_for_leading_digits( 1, 2 ),
    21, "calc_f_delta_for_leading_digits(1,2)",
);

# TEST
is( f_d_n( 1, 1 ), 1, "f_d_n(1,1)", );

# TEST
is( f_d_n( 1, 2 ), 1, "f_d_n(1,2)", );

# TEST
is( f_d_n( 1, 10 ), 2, "f_d_n(1, 10)", );

# TEST
is( f_d_n( 1, 11 ), 4, "f_d_n(1, 11)", );

# TEST
is( f_d_n( 1, 12 ), 5, "f_d_n(1, 12)", );

# TEST
is( f_d_n( 1, 20 ), 12, "f_d_n(1, 20)", );

# TEST
is( f_d_n( 1, 21 ), 13, "f_d_n(1, 21)", );

{
    # A mega-test.
    my @f_ds = ( (0) x 10 );

    for my $n ( 1 .. 1000 )
    {
        foreach my $d ( split //, $n )
        {
            $f_ds[$d]++;
        }
        foreach my $d ( 1 .. 9 )
        {
            # TEST*9*1000
            is( f_d_n( $d, $n ), $f_ds[$d], "Mega-test f(d=$d,n=$n)", );
        }
    }
}
