#!/usr/bin/perl

use strict;
use warnings;

use List::Util (qw(sum));
use List::MoreUtils (qw(all));

my $limit = 100_000_000;

my $primes_bitmask = "";
my $primes_list = "";

my $loop_to = int(sqrt($limit));
my $num_primes = 0;
for my $p (2 .. $loop_to)
{
    if (vec($primes_bitmask, $p, 1) == 0)
    {
        vec($primes_list, $num_primes++, 32) = $p;
        my $i = $p * $p;
        my $step = +($p == 2) ? 2 : ($p << 1);
        while ($i < $limit)
        {
            vec($primes_bitmask, $i, 1) = 1;
        }
        continue
        {
            $i += $step;
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

my $num_to_find = 5;
sub recurse
{
    my $indexes = shift;
    my $level = @$indexes;

    my @p = (map { vec($primes_list, $_, 32) } @$indexes);

    if ($level == $num_to_find)
    {
        # Let's check.
        print "Found: ", join(",", @p), " ; sum == ", sum(@p), "\n";

        return;
    }
    foreach my $idx ($num_to_find-$level-1 .. $indexes->[0]-1)
    {
        # 2 or 5 should be skipped because they never generate a pair
        if (($idx == 0) || ($idx == 2))
        {
            next;
        }

        my $new_p = vec($primes_list, $idx, 32);

        if (all { 
                (!vec($primes_bitmask, $new_p.$_, 1))
                    &&
                (!vec($primes_bitmask, $_.$new_p, 1))
            }
            @p)
        {
            recurse([$idx, @$indexes]);
        }
    }

    return;
}

foreach my $max_idx (6 .. 10_000)
{
    print "MaxIdx = $max_idx\n";
    recurse([$max_idx]);
}
