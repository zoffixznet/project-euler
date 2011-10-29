#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

use integer;

use List::MoreUtils qw(any all);

STDOUT->autoflush(1);

my @C;

# Matches $X,$Y,$Z (where $X >= $Y >= $Z) to the cuboid array and maximal 
# reached layer.
my %cuboids;

my $max_C_n = 0;

sub add_layer
{
    my ($x_lim, $y_lim, $z_lim) = @_;

    my $key = "$x_lim,$y_lim,$z_lim";

    my $rec = $cuboids{$key};

    return add_count($rec->{n} += ((($x_lim+$y_lim+$z_lim)<<2) + ($rec->{d} += 8)));
}

sub add_count
{
    my ($count) = @_;

    if ((++$C[$count]) > $max_C_n)
    {
        print "Found C[$count] == $C[$count]\n";
        $max_C_n = $C[$count];

        if ($max_C_n == 1000)
        {
            exit(0);
        }
    }

    return;
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
            # my $initial_cuboid =
            # [ map { 
            # [ map { [(1)x$z] } (1 .. $y) ]
            # } 
            # (1 .. $x)
            # ];
            #
            my $new_layer_count = 
                (($x*$y+$x*$z+$z*$y)<<1);

            # We increase the depth by 8 each time.
            $cuboids{"$x,$y,$z"} =
                { d => -8, n => $new_layer_count};

            add_count($new_layer_count);
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
