#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum min max);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $PI = atan2( 1, 1 ) * 4;
my $MIN_COS = cos( 120 * $PI / 180 );
for my $c ( 1 .. 120_000 )
{
    print "C=$c\n";
    for my $aa ( 1 .. $c )
    {
        my $numer = $aa * $aa - $c * $c;
        my $denom = 1 / ( 2 * $aa );

        # $c < $aa + $bb
        # $bb > $c - $aa
    B:
        for my $bb ( reverse( max( $c - $aa + 1, 1 ) .. $aa ) )
        {
            my $cos_C = ( $numer / $bb + $bb ) * $denom;
            if ( $cos_C <= $MIN_COS )
            {
                # print "Skipping [$c,$aa,$bb]\n";
                last B;
            }
            else
            {
                # print "Not skipping [$c,$aa,$bb]\n";
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
