package Euler156_V2;

use strict;
use warnings;

# use integer;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(max sum);
use List::MoreUtils qw();

use parent 'Exporter';

our @EXPORT_OK = qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

sub calc_f_delta
{
    my ($exp) = @_;

    return ( $exp + 1 ) * ( 10**$exp );
}

sub calc_f_delta_for_leading_digits
{
    my ( $num_digits_after, $num_leading_d_digits ) = @_;

    return $num_leading_d_digits * 10**$num_digits_after + (
        ( $num_digits_after - 1 >= 0 )
        ? calc_f_delta( $num_digits_after - 1 )
        : 0
    );
}

sub f_d_n
{
    my ( $d, $n ) = @_;

    my @digits = reverse( split( //, ( $n + 1 ) . '' ) );

    my $ret = 0;

    my $num_leading_d_digits = 0;

    foreach my $place ( reverse( keys @digits ) )
    {
        my $place_d = $digits[$place];

        my $place_d_min = $place_d - 1;
        my $d_in        = ( $d <= $place_d_min );

        $ret +=
            calc_f_delta_for_leading_digits( $place, $num_leading_d_digits ) *
            max( 0, $place_d - ( $d_in ? 1 : 0 ) ) + (
            $d_in
            ? calc_f_delta_for_leading_digits( $place,
                $num_leading_d_digits + 1 )
            : 0
            );

        if ( $place_d == $d )
        {
            $num_leading_d_digits++;
        }
    }

    return $ret;
}

1;

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
