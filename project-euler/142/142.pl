#!/usr/bin/perl

use strict;
use warnings;

use integer;

use IO::All;

# use Math::BigInt lib => 'GMP';

sub is_square
{
    my $n = shift;

    # my $root = int($n->copy->bsqrt());
    my $root = int( sqrt($n) );

    return ( $root * $root == $n );
}

my $milestone_step = 10_000;
my $next_milestone = $milestone_step;

foreach my $x ( 1 .. 1_000_000 )
{
    my $x_diff = 1;
Y_LOOP:
    for ( my $y = $x - 1 ; $y > 0 ; $y -= ( $x_diff += 2 ) )
    {
        if ( !is_square( $x + $y ) )
        {
            next Y_LOOP;
        }
        if ( $x >= $next_milestone )
        {
            print "Reached X=$x Y=$y\n";
            $next_milestone += $milestone_step;
        }

        my $y_diff = 1;
        for ( my $z = $y - 1 ; $z > 0 ; $z -= ( $y_diff += 2 ) )
        {
            if (    is_square( $y + $z )
                and is_square( $x - $z )
                and is_square( $x + $z ) )
            {
                print "Found X=$x Y=$y Z=$z S=@{[$x+$y+$z]}\n";
                exit(0);
            }
        }
    }
}

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
