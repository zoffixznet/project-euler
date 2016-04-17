#!/usr/bin/perl

use strict;
use warnings;



sub calc_A
{
    my ($n) = @_;

    my $mod = 1;
    my $len = 1;

    while ($mod)
    {
        $mod = (($mod * 10 + 1) % $n);
        $len++;
    }

    return $len;
}

open my $primes_fh, "primes 7|";
my $last_prime =

my $count = 0;
my $sum = 0;

while ($count < 40)
{
    my $n = int(scalar(<$primes_fh>));
    {
        my $A = calc_A($n);
        if (1_000_000_000 % $A == 0)
        {
            $count++;
            $sum += $n;
            print "Found $n ; Sum = $sum ; Count = $count\n";
        }
    }
}

close($primes_fh);
