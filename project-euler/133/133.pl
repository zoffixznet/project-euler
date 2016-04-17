#!/usr/bin/perl

use strict;
use warnings;

use integer;



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

sub is_div
{
    my ($n) = @_;

    my $A = calc_A($n);

    while (($A & 0x1) == 0)
    {
        $A >>= 1;
    }

    while ($A % 5 == 0)
    {
        $A /= 5;
    }

    return ($A == 1);
}

open my $primes_fh, "(echo 3 ; primes 7 100000)|";

# 2 and 5 are such primes and calc_A() will get stuck for them.
my $sum = 2 + 5;

while (my $line = <$primes_fh>)
{
    my $n = int($line);
    print "Checking $n\n";
    if (! is_div($n))
    {
        $sum += $n;
    }
}

close($primes_fh);

print "Sum = $sum\n";
