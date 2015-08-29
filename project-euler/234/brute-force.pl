#!/usr/bin/perl

use strict;
use warnings;

use POSIX qw(ceil floor);

my %p = (map { $_ => 1 } map { /(\d+)/ ? $1 : () } `primes 2 1000`);
for my $n (4 .. 1000)
{
    my $c = 0;
    {
        my $s = floor(sqrt($n));
        while (!exists($p{$s}))
        {
            $s--;
        }
        if ($n % $s == 0)
        {
            $c++;
        }
    }
    {
        my $s = ceil(sqrt($n));
        while (!exists($p{$s}))
        {
            $s++;
        }
        if ($n % $s == 0)
        {
            $c++;
        }
    }
    if ($c == 1)
    {
        print "$n\n";
    }
}
