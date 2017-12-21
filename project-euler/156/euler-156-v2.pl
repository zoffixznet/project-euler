#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use lib '.';
use Euler156_V2 qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

my @found = ( map { +{} } 0 .. 9 );

sub check
{
    my ( $d, $first, $f_first, $last, $f_last ) = @_;

    # print "[@_]\n";
    if ( $first >= $last )
    {
        if ( $f_first == $first )
        {
            $found[$d]{$first} = 1;
        }
    }
    elsif ( $last == $first + 1 )
    {
        check( $d, $first, $f_first, $first, $f_first );
        check( $d, $last,  $f_last,  $last,  $f_last );
    }
    else
    {
        my $mid = ( ( $first + $last ) >> 1 );

        if ( $mid == $first )
        {
            $mid++;
        }
        if ( $mid < $first or $mid > $last )
        {
            die "Foo";
        }
        my $f_mid = f_d_n( $d, $mid );

        if ( not( $f_first > $mid or $f_mid < $first ) )
        {
            check( $d, $first, $f_first, $mid, $f_mid );
        }

        if ( not( $f_mid > $last or $f_last < $mid ) )
        {
            check( $d, $mid, $f_mid, $last, $f_last );
        }
    }

    return;
}

my $total_sum = 0;

for my $d ( 1 .. 9 )
{
    my $first    = 1;
    my $last     = ( $first << 1 );
    my $continue = 1;
    while ($continue)
    {
        my $f_first = f_d_n( $d, $first );
        my $f_last  = f_d_n( $d, $last );

        if ( $f_first > $last )
        {
            $continue = 0;
            print "Cannot be (f_d_n > n) in range [$first .. $last]\n";
        }
        elsif ( $f_last < $first )
        {
            print "Cannot be (f_d_n < n) in range [$first .. $last]\n";
        }
        else
        {
            print "I don't know in range [$first .. $last]\n";
            check( $d, $first, $f_first, $last, $f_last );
        }
    }
    continue
    {
        $first = $last;
        $last <<= 1;
    }

    my $sum = 0;
    for my $k ( keys( %{ $found[$d] } ) )
    {
        $sum += $k;
    }

    print "s($d) = $sum\n";
    $total_sum += $sum;
}
print "total_sum = $total_sum\n";

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
