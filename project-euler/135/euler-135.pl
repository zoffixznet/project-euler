#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 ANALYSIS

(z+2d)^2 - (z+d)^2 - z^2 = z^2+4dz+4d^2 - z^2 - 2dz - d^2 - z^2 =
-z^2 + 2dz +3d^2 = (-z + 3d)(z + d)
=cut

my $solution_counts_vec = '';
my $ten_counts          = 0;

my $LIMIT = 1_000_000;

for my $z ( 1 .. $LIMIT )
{
    print "Z = $z ; Ten Counts = $ten_counts\n" if ( $z % 10_000 == 0 );
    my $d = ( int( $z / 3 ) + 1 );

D_LOOP:
    while (1)
    {
        my $n = ( 3 * $d - $z ) * ( $z + $d );

        if ( $n >= $LIMIT )
        {
            last D_LOOP;
        }
        elsif ( $n > 0 )
        {
            my $c = vec( $solution_counts_vec, $n, 4 );
            $c++;
            if ( $c == 11 )
            {
                $ten_counts--;
            }
            elsif ( $c == 12 )
            {
                # Make sure it doesn't overflow.
                $c--;
            }
            elsif ( $c == 10 )
            {
                $ten_counts++;
            }
            vec( $solution_counts_vec, $n, 4 ) = $c;
        }
    }
    continue
    {
        $d++;
    }
}

print "Ten counts = $ten_counts\n";

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
