#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

use integer;

STDOUT->autoflush(1);

my @C;

# Used to be:
# <<<
# Matches $X,$Y,$Z (where $X >= $Y >= $Z) to the cuboid array and maximal
# reached layer.
# >>>
# Now we no longer need the $X,$Y,$Z.
#
# Since the counts are divisible by 2 and are kept multiplied by 2, we
# keep their halfs.

my $max_C_n = 0;

my $LIMIT = 50_000;

my $z = 1;

Z_LOOP:
while (1)
{
    print "Checking z=$z\n";
Y_LOOP:
    for my $y ( 1 .. $z )
    {
    X_LOOP:
        for my $x ( 1 .. $y )
        {
            my $new_layer_count = ( $x * ( $y + $z ) + $z * $y );

            my $delta = ( ( ( $x + $y + $z ) << 1 ) - 4 );

            if ( $new_layer_count >= $LIMIT )
            {
                if ( $x == 1 )
                {
                    if ( $y == 1 )
                    {
                        last Z_LOOP;
                    }
                    else
                    {

                        last Y_LOOP;
                    }
                }
                else
                {
                    last X_LOOP;
                }
            }
            while ( $new_layer_count < $LIMIT )
            {
                $C[$new_layer_count]++;
                $new_layer_count += ( $delta += 4 );
            }
        }
    }
}
continue
{
    $z++;
}

foreach my $count ( 1 .. $#C )
{
    if ( defined( $C[$count] ) )
    {
        print "C[", ( $count * 2 ), "] = $C[$count]\n";
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
