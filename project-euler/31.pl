#!/usr/bin/perl

use strict;
use warnings;

my @coins = (1,2,5,10,20,50,100,200);

my @r_coins = (reverse(@coins));

my %cache = ();

sub calc
{
    my ($max_idx, $sum) = @_;

    if (exists($cache{"$max_idx,$sum"}))
    {
        return $cache{"$max_idx,$sum"}
    }
    else
    {
        my $ret;
        if ($max_idx == $#r_coins)
        {
            $ret = 1;
        }
        elsif ($sum < $r_coins[$max_idx])
        {
            $ret = calc($max_idx+1, $sum);
        }
        else
        {
            $ret = calc($max_idx+1, $sum)+calc($max_idx, $sum-$r_coins[$max_idx]);
        }
        return $cache{"$max_idx,$sum"} = $ret;
    }
}

print calc(0, 200), "\n";
