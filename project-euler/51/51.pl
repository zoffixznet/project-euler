#!/usr/bin/perl

use strict;
use warnings;

my $limit = 1_000_000;

my $primes_bitmask = "";

my $loop_to = int(sqrt($limit));
for my $p (2 .. $loop_to)
{
    if (vec($primes_bitmask, $p, 1) == 0)
    {
        my $i = $p * $p;
        while ($i < $limit)
        {
            vec($primes_bitmask, $i, 1) = 1;
        }
        continue
        {
            $i += $p;
        }
    }
}

NUM_LOOP:
for my $n (10 .. $limit)
{
    if ( $n !~ /1/ || $n =~ /1\z/)
    {
        next NUM_LOOP;
    }
    my @found = (grep { my $m = $n; $m =~ s/1/$_/g; !vec($primes_bitmask, $m, 1) } (0 .. 9));
    if (@found >= 8)
    {
        my $m = $n;
        $m =~ s/1/$found[0]/g;
        print "$m\n";
    }
}
