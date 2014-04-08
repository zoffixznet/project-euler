#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

my $MOD = 1_000_000_000;

sub f_mod
{
    my ($n) = @_;

    if ($n == 1)
    {
        return 1;
    }
    elsif ($n == 3)
    {
        return 3;
    }
    elsif (($n & 1) == 0)
    {
        return f_mod($n >> 1);
    }
    elsif (($n & 3) == 1)
    {
        return (2 * f_mod(($n >> 1) + 1) - f_mod($n >> 2)) % $MOD;
    }
    else
    {
        return (3 * f_mod(($n >> 1) + 1) - 2 * f_mod($n >> 2)) % $MOD;
    }
}

foreach my $n (1 .. 1_000_000_000)
{
    say f_mod($n);
}
