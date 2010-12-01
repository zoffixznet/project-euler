#!/usr/bin/perl

use strict;
use warnings;

use List::Util (qw(sum));
use List::MoreUtils (qw(all));

my $limit = 100_000_000;


my $primes_bitmask = "";
my $primes_list = "";
my $num_primes = 0;

if (! -e "$limit.bitmask")
{
    my $loop_to = int(sqrt($limit));

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

    open O, ">", "$limit.bitmask";
    binmode O;
    print O $primes_bitmask;
    close(O);

    open O, ">", "$limit.list";
    binmode O;
    print O $primes_list;
    close(O);
}
else
{
    local $/;
    open I, "<", "$limit.bitmask";
    binmode(I);
    $primes_bitmask = <I>;
    close(I);
    open I, "<", "$limit.list";
    binmode(I);
    $primes_list = <I>;
    close(I);
    $num_primes = (length($primes_list)>>2);
}

my $num_to_find = 5;

my @sets = (map { +{} } (0 .. $num_to_find));
my $objective = $sets[$num_to_find];

# Skip 2
for my $i (1 .. 10_000)
{
    # Skip 5
    next if ($i == 2);

    if ($i % 100 == 0)
    {
        print "Reached $i\n";
    }

    my $new_p = vec($primes_list, $i, 32);
    
    for my $order (reverse(2 .. ($num_to_find-1)))
    {
        foreach my $set (keys(%{$sets[$order]}))
        {
            my @p = split(/,/, $set);
            if (all { 
                (!vec($primes_bitmask, $new_p.$_, 1))
                    &&
                (!vec($primes_bitmask, $_.$new_p, 1))
            }
            @p)
            {
                push @p, $new_p;
                $sets[$order+1]->{join(",",@p)} = sum(@p);
            }
        }
    }
    
    if (keys(%$objective))
    {
        print  map { "$_ => $objective->{$_}\n" }
              sort { $objective->{$a} <=> $objective->{$b} } 
              keys(%$objective)
              ;
    }

    for my $prev (1 .. $i-1)
    {
        next if ($prev == 2);

        my $p = vec($primes_list, $prev, 32);

        if ((!vec($primes_bitmask, $new_p.$p, 1))
            &&
            (!vec($primes_bitmask, $p.$new_p, 1)))
        {
            $sets[2]{"$p,$new_p"} = sum($p,$new_p);
        }
    }
}
