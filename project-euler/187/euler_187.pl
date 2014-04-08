#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use 5.016;

my $limit = 100_000_000;
my $half_limit = ($limit >> 1);
my @p = `primes 2 $half_limit`;
chomp(@p);

my $count = 0;

my $end_idx = $#p;
P_INDEX:
for my $start_idx (keys@p)
{
    my $p = $p[$start_idx];
    while ($p[$end_idx] * $p >= $limit)
    {
        $end_idx--;
    }
    if ($end_idx < $start_idx)
    {
        last P_INDEX;
    }
    $count += $end_idx-$start_idx+1;
}

# chomp($count_primes);

say "Answer = $count";
