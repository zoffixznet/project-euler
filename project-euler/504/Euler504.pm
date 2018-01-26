package Euler504;

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $M;
my %cache;

sub set_M
{
    $M = shift;

    %cache = ();

    return;
}

sub calc_tri
{
    my ( $x, $y ) = sort { $a <=> $b } @_;

    return $cache{"$x,$y"} //= sub {

        # my $dy = $y / $x;

        my $count = 0;
        my $edges = $y + $x - 1;

        for my $i ( 0 .. $x )
        {
            my $len = $y * $i;
            $count += int( $len / $x );
            if ( $len % $x )
            {
                $count++;
            }
        }

        return [ $count, $edges ];
        }
        ->();
}

sub calc_all_quadris
{
    my $ret = 0;

    for my $A ( 1 .. $M )
    {
        for my $B ( 1 .. $M )
        {
            print "A,B=$A,$B\n";
            my $AB = calc_tri( $A, $B );

            for my $C ( 1 .. $M )
            {
                my $BC = calc_tri( $B, $C );

                my $ABC = [ $AB->[0] + $BC->[0], $AB->[1] + $BC->[1] ];

                for my $D ( 1 .. $M )
                {
                    my $CD = calc_tri( $C, $D );
                    my $AD = calc_tri( $A, $D );

                    # We add 3 for the
                    my $count =
                        $ABC->[0] +
                        $CD->[0] +
                        $AD->[0] -
                        ( ( $ABC->[1] + $CD->[1] + $AD->[1] ) >> 1 ) - 1;

                    my $root = int( sqrt($count) );
                    if ( $root * $root == $count )
                    {
                        $ret++;
                    }
                }
            }
        }
    }

    return $ret;
}

1;

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
