#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

use integer;

use List::MoreUtils qw(any all);

STDOUT->autoflush(1);

use constant DELTA => 0;
use constant COUNT => 1;

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
my @cuboids;

my $max_C_n = 0;

sub add_count
{
    my ($count) = @_;

    if ( ( ++$C[$count] ) > $max_C_n )
    {
        print "Found C[@{[$count*2]}] == $C[$count]\n";
        $max_C_n = $C[$count];

        if ( $max_C_n == 1000 )
        {
            exit(0);
        }
    }

    return;
}

my $max_layer_size = 1;

while (1)
{
    for my $z ( 1 .. $max_layer_size )
    {
    Y_LOOP:
        for my $y ( $z .. $max_layer_size / $z )
        {
            my $x = $max_layer_size / $z / $y;

            if (   $x * $y * $z != $max_layer_size
                or $x < $y )
            {
                next Y_LOOP;
            }

            # print "$x,$y,$z\n";
            # my $initial_cuboid =
            # [ map {
            # [ map { [(1)x$z] } (1 .. $y) ]
            # }
            # (1 .. $x)
            # ];
            #
            my $new_layer_count = ( $x * ( $y + $z ) + $z * $y );

            # We increase the depth's delta by 8 each time.
            push @cuboids,
                [ ( ( ( $x + $y + $z ) << 1 ) - 4 ), $new_layer_count ];

            add_count($new_layer_count);
        }
    }

    # Now add extra layers to the existing cuboids.
    foreach my $rec (@cuboids)
    {
        while ( $rec->[COUNT] < $max_layer_size )
        {
            add_count( $rec->[COUNT] += ( $rec->[DELTA] += 4 ) );
        }
    }
}
continue
{
    $max_layer_size++;
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
