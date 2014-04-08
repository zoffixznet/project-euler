#!/usr/bin/perl

use strict;
use warnings;

sub is_prime
{
    my ($n) = @_;

    if ($n <= 1)
    {
        return 0;
    }

    my $top = int(sqrt($n));

    for my $i (2 .. $top)
    {
        if ($n % $i == 0)
        {
            return 0;
        }
    }

    return 1;
}

sub is_circ_prime
{
    my $n = shift;
    if ($n =~ /0/)
    {
        return;
    }
    else
    {
        my $l = length($n);
        for my $i (1 .. $l)
        {
            if (!is_prime($n))
            {
                return;
            }
            $n = substr($n,1) . substr($n,0,1);
        }
        return 1;
    }
}

my $count;
foreach my $n (2 .. 1_000_000)
{
    if (is_circ_prime($n))
    {
        $count++;
    }
}
print "$count\n";
