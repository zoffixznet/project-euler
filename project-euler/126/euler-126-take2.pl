#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(any all);

my @C;

# Matches $X,$Y,$Z (where $X >= $Y >= $Z) to the cuboid array and maximal
# reached layer.
my %cuboids;

my $max_C_n = 0;

sub add_layer
{
    my ( $x_lim, $y_lim, $z_lim ) = @_;

    my $key = "$x_lim,$y_lim,$z_lim";

    my $depth = $cuboids{$key}->{d};

    my $new_layer_count = 0;

    my $calc_dist = sub {
        my ( $x, $x_lim ) = @_;

        return (
              ( $x < 0 ) ? abs($x)
            : ( $x >= $x_lim ) ? ( $x - ( $x_lim - 1 ) )
            : 0
        );
    };

    foreach my $x ( -$depth .. $x_lim + $depth - 1 )
    {
        my $dist_x = $calc_dist->( $x, $x_lim );

        foreach my $y ( -$depth .. $y_lim + $depth - 1 )
        {
            my $dist_y = $calc_dist->( $y, $y_lim );

            foreach my $z ( -$depth .. $z_lim + $depth - 1 )
            {
                my $dist_z = $calc_dist->( $z, $z_lim );

                if ( $dist_x + $dist_y + $dist_z == $depth )
                {
                    $new_layer_count++;
                }
            }
        }
    }

    $cuboids{$key} = { d => ( $depth + 1 ), n => $new_layer_count };

    if ( ( ++$C[$new_layer_count] ) > $max_C_n )
    {
        print "Found C[$new_layer_count] == $C[$new_layer_count]\n";
        $max_C_n = $C[$new_layer_count];

        if ( $max_C_n == 1000 )
        {
            exit(0);
        }
    }
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
            my $initial_cuboid = [
                map {
                    [ map { [ (1) x $z ] } ( 1 .. $y ) ]
                } ( 1 .. $x )
            ];

            $cuboids{"$x,$y,$z"} = { d => 1, n => $max_layer_size };

            add_layer( $x, $y, $z );
        }
    }

    # Now add extra layers to the existing cuboids.

    # So we won't update the hash in place.
    my @to_update;

    while ( my ( $initial_dims, $data ) = each(%cuboids) )
    {
        if ( $data->{n} < $max_layer_size )
        {
            push @to_update, $initial_dims;
        }
    }

    foreach my $dims (@to_update)
    {
        add_layer( split( /,/, $dims ) );
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
