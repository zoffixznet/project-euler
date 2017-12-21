#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub check
{
    my ( $n, $x, $y, $z ) = ( map { Math::BigInt->new("$_") } @_ );

    if ( $x**( $n + 1 ) +
        $y**( $n + 1 ) -
        $z**( $n + 1 ) +
        ( $x * $y + $y * $z + $z * $x ) *
        ( $x**( $n - 1 ) + $y**( $n - 1 ) - $z**( $n - 1 ) ) -
        $x * $y * $z *
        ( $x**( $n - 2 ) + $y**( $n - 2 ) - $z**( $n - 2 ) ) !=
        ( ( $x + $y + $z ) * ( $x**$n + $y**$n - $z**$n ) ) )
    {
        print "$x,$y,$z\[n=$n] Mismatch.\n";
        die "Foo";
    }

    return;
}

for my $z ( 1 .. 100 )
{
    for my $x ( 1 .. $z )
    {
        for my $y ( 1 .. $x )
        {
            for my $n ( 3 .. 10 )
            {
                print "Checking $x,$y,$z,$n\n";
                check( $n, $x, $y, $z );
            }
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
