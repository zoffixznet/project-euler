#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 DESCRIPTION

Consider the consecutive primes p1 = 19 and p2 = 23. It can be verified that
1219 is the smallest number such that the last digits are formed by p1 whilst
also being divisible by p2.

In fact, with the exception of p1 = 3 and p2 = 5, for every pair of consecutive
primes, p2 > p1, there exist values of n for which the last digits are formed
by p1 and n is divisible by p2. Let S be the smallest of these values of n.

Find ∑ S for every pair of consecutive primes with 5 ≤ p1 ≤ 1000000.

=cut

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

open my $primes_fh, "(primes 5 1100000)|";

my $p1 = int(<$primes_fh>);
my $p2;
my $sum = 0;
my $count = 0;
PRIMES_LOOP:
while ($p2 = int(<$primes_fh>))
{
    if ($p1 > 1_000_000)
    {
        last PRIMES_LOOP;
    }
    my $mod = $p1;
    my $mod_delta = ((1 . ('0' x length($p1))) % $p2);

    my $i = 0;
    while (($mod % $p2) != 0)
    {
        $mod += $mod_delta;
        $i++;
    }
    my $S = ($i . $p1);
    $sum += $S;

    if ((++$count) % 100 == 0)
    {
        print "For (p1=$p1,p2=$p2) found $S (sum=$sum)\n";
    }
}
continue
{
    $p1 = $p2;
}

close($primes_fh);

print "Sum = $sum\n";
