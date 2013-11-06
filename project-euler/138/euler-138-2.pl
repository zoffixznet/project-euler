#!/usr/bin/perl

use strict;
use warnings;

use integer;

# use Math::BigInt lib => 'GMP', ':constant';

sub get_valid_n_mods_for_base
{
    my ($base) = @_;

    my %valid_L_squared_mods;

    for my $L (0 .. $base-1)
    {
        $valid_L_squared_mods{($L * $L) % $base} = 1;
    }

    my @valid_n_mods;
    for my $n (0 .. $base-1)
    {
        my $modulo = ((1 + $n * (4 + $n * 5))%$base);
        if (exists($valid_L_squared_mods{$modulo}))
        {
            push @valid_n_mods, $n;
        }
    }

    return \@valid_n_mods;
}

my $base = 95_480;
my $count = 0;
my $sum_L = 0;
my $base_n = 0;
my $valid_mods = get_valid_n_mods_for_base($base);
my $L = 1;
my $L_sq = 1;
my $L_sq_delta = 1;

while (1)
{
    foreach my $delta (@$valid_mods)
    {
        my $n = $base_n + $delta;

        my ($prev_L, $prev_L_sq, $prev_L_sq_delta);
        foreach my $result (1+$n*(4+5*$n))
        {
            while ($L_sq < $result)
            {
                ($prev_L, $prev_L_sq, $prev_L_sq_delta)
                    = ($L, $L_sq, $L_sq_delta);
                $L++;
                $L_sq += ($L_sq_delta += 2);
            }

            if ($L_sq == $result)
            {
                $sum_L += $L;
                $count++;
                print "Found $L [$n] ; Sum = $sum_L ; Count = $count\n";
            }
            else
            {
                ($L, $L_sq, $L_sq_delta) =
                    ($prev_L, $prev_L_sq, $prev_L_sq_delta);
            }

        }
    }
}
continue
{
    $base_n += $base;
}
