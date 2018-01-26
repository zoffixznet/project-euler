#!/usr/bin/perl

use strict;
use warnings;

=begin foo
    my $new_layer_count = 0;

    my $calc_dist = sub {
        my ($x, $x_lim) = @_;

        return
            (($x < 0) ? abs($x) : ($x >= $x_lim) ? ($x-($x_lim-1)) : 0);
    };

    foreach my $x (-$depth .. $x_lim+$depth-1)
    {
        my $dist_x = $calc_dist->($x,$x_lim);

        foreach my $y (-$depth .. $y_lim + $depth-1)
        {
            my $dist_y = $calc_dist->($y,$y_lim);

            foreach my $z (-$depth .. $z_lim + $depth-1)
            {
                my $dist_z = $calc_dist->($z, $z_lim);

                if ($dist_x+$dist_y+$dist_z == $depth)
                {
                    $new_layer_count++;
                }
            }
        }
    }

    if ($new_layer_count != $expected_new_layer_count)
    {
       die "\$new_layer_count != \$expected_new_layer_count ==
        $new_layer_count != $expected_new_layer_count for depth $depth
            and ($x_lim,$y_lim,$z_lim).";
    }

=end foo

=cut

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
