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
