#!/usr/bin/perl

use strict;
use warnings;

use List::Util (qw(sum));

my $limit = 1_000_000;

my $primes_bitmask = "";
my $primes_list = "";

my $loop_to = int(sqrt($limit));
my $num_primes = 0;
for my $p (2 .. $loop_to)
{
    if (vec($primes_bitmask, $p, 1) == 0)
    {
        vec($primes_list, $num_primes++, 32) = $p;
        my $i = $p + $p;
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

for my $p ($loop_to .. $limit)
{
    if (vec($primes_bitmask, $p, 1) == 0)
    {
        vec($primes_list, $num_primes++, 32) = $p;
    }
}
print "$num_primes\n";

my $max_sum;
my $max_count = 21;
START_LOOP:
for (my $start_idx = 0 ; $start_idx < $num_primes-$max_count ; $start_idx++)
{
    my $end_idx= $start_idx+$max_count;
    my $sum = sum (
        map
        { vec($primes_list, $_, 32) }
        ($start_idx .. $end_idx)
    );

    if ($sum > $limit)
    {
        last START_LOOP;
    }
    END_LOOP:
    for (; $end_idx < $num_primes ; $sum += vec($primes_list, ++$end_idx, 32))
    {
        if ($sum > $limit)
        {
            last END_LOOP;
        }
        if (vec($primes_bitmask, $sum, 1) == 0)
        {
            $max_count = $end_idx-$start_idx+1;
            $max_sum = $sum;
            print "Found MaxCount = $max_count ; MaxSum = $max_sum ;\n";
        }
    }
}

print "Found MaxCount = $max_count ; MaxSum = $max_sum ;\n";
