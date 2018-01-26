#!/usr/bin/perl

use strict;
use warnings;

use 5.014;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

sub make_pair
{
    my ( $A, $L ) = @_;

    return "$A,$L";
}

sub parse_pair
{
    return split /,/, shift;
}

my @counts;
$counts[0] = { make_pair( 0, 0 ) => 1 };

sub step
{
    my ($n) = @_;

    my $next = ( $counts[$n] //= +{} );

    while ( my ( $pair, $count ) = each( %{ $counts[ $n - 1 ] } ) )
    {
        my $add = sub {
            my ( $A, $L ) = @_;

            $next->{ make_pair( $A, $L ) } += $count;

            return;
        };

        my ( $num_A, $num_L ) = parse_pair($pair);

        # Handle O - On-time.
        $add->( 0, $num_L );

        # Handle A - Absent.
        if ( $num_A < 3 - 1 )
        {
            $add->( $num_A + 1, $num_L );
        }

        # Handle L - Late.
        if ( $num_L < 1 )
        {
            $add->( 0, $num_L + 1 );
        }
    }
    return;
}

sub calc_count
{
    my ($n) = @_;

    return sum( values( %{ $counts[$n] } ) );
}

my $pivot = 4;
for my $n ( 1 .. $pivot )
{
    step($n);
}

say "Count[$pivot] = ", calc_count($pivot);

my $desired = 30;
for my $n ( ( $pivot + 1 ) .. $desired )
{
    step($n);
}

say "Count[$desired] = ", calc_count($desired);

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

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
