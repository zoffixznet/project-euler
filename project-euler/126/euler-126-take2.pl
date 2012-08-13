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
    my ($x_lim, $y_lim, $z_lim) = @_;

    my $key = "$x_lim,$y_lim,$z_lim";

    my $depth = $cuboids{$key}->{d};

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

    $cuboids{$key} = {d => ($depth+1), n => $new_layer_count};

    if ((++$C[$new_layer_count]) > $max_C_n)
    {
        print "Found C[$new_layer_count] == $C[$new_layer_count]\n";
        $max_C_n = $C[$new_layer_count];

        if ($max_C_n == 1000)
        {
            exit(0);
        }
    }
}

my $max_layer_size = 1;

while (1)
{
    for my $z (1 .. $max_layer_size)
    {
        Y_LOOP:
        for my $y ($z .. $max_layer_size/$z)
        {
            my $x = $max_layer_size/$z/$y;

            if ($x * $y * $z != $max_layer_size 
                    or
                $x < $y)
            {
                next Y_LOOP;
            }

            # print "$x,$y,$z\n";
            my $initial_cuboid =
                [ map { 
                    [ map { [(1)x$z] } (1 .. $y) ]
                    } 
                    (1 .. $x)
                ];

            $cuboids{"$x,$y,$z"} = 
                { d => 1, n => $max_layer_size };

            add_layer($x, $y, $z);
        }
    }

    # Now add extra layers to the existing cuboids.

    # So we won't update the hash in place.
    my @to_update;

    while (my ($initial_dims, $data) = each (%cuboids))
    {
        if ($data->{n} < $max_layer_size)
        {
            push @to_update, $initial_dims;
        }
    }

    foreach my $dims (@to_update)
    {
        add_layer (split(/,/, $dims));
    }
}
continue
{
    $max_layer_size++;
}
