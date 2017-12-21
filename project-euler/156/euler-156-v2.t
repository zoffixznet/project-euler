#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Test::More tests => 9015;

use lib '.';
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

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
