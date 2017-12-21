#!/usr/bin/perl

use strict;
use warnings;

use Math::MatrixReal;

use List::Util;

=head1 Planning.

Suppose we have n terms for which the polynomial yields (a1, a2, a3 ... an).
Then we can have:

c_0 + c_1 * 1 + c_2 * 1 ** 2 ... + c_n-1 * 1 ** n-1 = a_1
c_0 + c_1 * 2 + c_2 * 2 ** 2 ... + c_n-1 * 2 ** n-1 = a_2
c_0 + c_1 * 3 + c_2 * 3 ** 2 ... + c_n-1 * 3 ** n-1 = a_3

So we can find c_0 ... c_n-1 by solving the co-efficients problem.

=cut

sub find_coeff
{
    my ($a_s) = @_;

    my $coeffs = Math::MatrixReal->new_from_rows(
        [
            map {
                my $x = $_;
                [ map { $x**$_ } ( 0 .. $#$a_s ) ]
            } ( 1 .. scalar(@$a_s) )
        ]
    );

    $coeffs->transpose($coeffs);

    my $a_mat = Math::MatrixReal->new_from_rows( [ map { [$_] } @$a_s ] );

    return $coeffs->inverse() * $a_mat;
}

sub get_bop
{
    my ($a_s) = @_;

    return (
        Math::MatrixReal->new_from_rows(
            [ [ map { @$a_s**$_ } 1 .. scalar(@$a_s) ] ]
        ) * find_coeff($a_s)
    )->element( 1, 1 );
}

my @u_coeffs = ( map { (-1)**$_ } ( 0 .. 10 ) );

sub calc_u_result_vec
{
    my $x = shift;

    return [ map { $x**$_ * $u_coeffs[$_] } ( 0 .. $#u_coeffs ) ];
}

sub calc_u_result
{
    my $x = shift;
    return List::Util::sum( @{ calc_u_result_vec($x) } );
}

my @u_results = ( map { calc_u_result($_) } ( 1 .. scalar(@u_coeffs) ) );

sub get_u_bop
{
    my $i = shift;

    return get_bop( [ @u_results[ 0 .. $i - 1 ] ] );
}

my $s = 0;
foreach my $i ( 1 .. 10 )
{
    my $val = get_u_bop($i);
    print "$i : $val\n";
    $s += $val;
}
print "$s\n";

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
