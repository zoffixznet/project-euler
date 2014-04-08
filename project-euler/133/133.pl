#!/usr/bin/perl

use strict;
use warnings;

use integer;

=head1 DESCRIPTION

A number consisting entirely of ones is called a repunit. We shall define R(k)
to be a repunit of length k; for example, R(6) = 111111.

Let us consider repunits of the form R(10n).

Although R(10), R(100), or R(1000) are not divisible by 17, R(10000) is
divisible by 17. Yet there is no value of n for which R(10n) will divide by 19.
In fact, it is remarkable that 11, 17, 41, and 73 are the only four primes
below one-hundred that can be a factor of R(10n).

Find the sum of all the primes below one-hundred thousand that will never be a
factor of R(10n).

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
