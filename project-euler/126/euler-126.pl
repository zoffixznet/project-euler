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
    my ($x, $y, $z) = @_;

    my $key = "$x,$y,$z";

    my $array = $cuboids{$key}->{array};

    my @dims = @{ $cuboids{$key}->{dims} };

    my @new_dims = (map { $_ + 2 } @dims);

    my $new_array =
        [ map { 
            [
            map
            { [(0)x($new_dims[2])] }
            (1 .. $new_dims[1])
            ]
            }
            (1 .. ($new_dims[0]))
        ];

    my @coords = (0, 0, 0);

    my $new_layer_count = 0;

    foreach my $xx (0 .. $new_dims[0]-1)
    {
        foreach my $yy (0 .. $new_dims[1]-1)
        {
            foreach my $zz (0 .. $new_dims[2]-1)
            {
                @coords = ($xx, $yy, $zz);

                if ($xx and $yy and $zz and $array->[$xx-1]->[$yy-1]->[$zz-1])
                {
                    $new_array->[$xx]->[$yy]->[$zz] = 1;
                }
                elsif (any {
                        my $deltas = $_;
                        my @nc = (map { $coords[$_]-1+$deltas->[$_] } (0 .. 2));

                        ((all { $_ >= 0 } @nc) and
                        $array
                        ->[$nc[0]]
                        ->[$nc[1]]
                        ->[$nc[2]]
                        )
                    } ([0,0,1],[0,0,-1],[0,1,0],[0,-1,0],[1,0,0],[-1,0,0])
                )
                {
                    $new_array->[$xx]->[$yy]->[$zz] = 1;
                    $new_layer_count++;
                }
            }
        }
    }

    $cuboids{$key} = {array => $new_array, dims => \@new_dims, n => $new_layer_count};

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
                { array => $initial_cuboid, dims => [$x,$y,$z], n => $max_layer_size };

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
