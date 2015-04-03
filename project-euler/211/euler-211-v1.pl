#!/usr/bin/perl

use strict;
use warnings;

use bytes;

no warnings 'portable';

my $factors = '';

my $sum = 1;
my $LIM = (64_000_000-1);
for my $n (2 .. $LIM)
{
    vec($factors, $n, 64) = 1;
}

# For $n == 1 whose sum of divisor squares are 1.
for my $n (2 .. $LIM)
{
    print "Reached N=$n sum = $sum\n";
    my $f = vec($factors, $n, 64);
    if ($f != 1)
    {
        # It's a composite number.
        my $s = int(sqrt($f));
        if ($s * $s == $f)
        {
            $sum += $n;
            print "Found $n for a total of $sum\n";
        }
    }
    else
    {
        # It's a prime.
        my $mult = $n;
        my $factor = 1 + $mult * $mult;
        my $vec = '';
        {
            my $prod = ($mult<<1);
            my $pos = 2;
            
            while ($prod < $LIM)
            {
                vec($vec, $pos, 64) = $factor;
            }
            continue
            {
                $prod += $mult;
                $pos++;
            }
        }
        $mult *= $n;

        my $pos_step = $n;

        while ($mult < $LIM)
        {
            $factor += $mult * $mult;
            my $prod = $mult;

            my $pos = $pos_step;
            while ($prod < $LIM)
            {
                vec($vec, $pos, 64) = $factor;
            }
            continue
            {
                $prod += $mult;
                $pos += $pos_step;
            }
        }
        continue
        {
            $mult *= $n;
            $pos_step *= $n;
        }

        my $pos = 2;
        for (my $prod = ($n << 1); $prod < $LIM ; $prod += $n)
        {
            vec($factors, $prod, 64) *= vec($vec, ($pos++), 64);
        }
    }
}
