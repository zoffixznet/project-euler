#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

A number consisting entirely of ones is called a repunit. We shall define R(k)
to be a repunit of length k; for example, R(6) = 111111.

Given that n is a positive integer and GCD(n, 10) = 1, it can be shown that
there always exists a value, k, for which R(k) is divisible by n, and let A(n)
be the least such value of k; for example, A(7) = 6 and A(41) = 5.

You are given that for all primes, p > 5, that p − 1 is divisible by A(p). For
example, when p = 41, A(41) = 5, and 40 is divisible by 5.

However, there are rare composite values for which this is also true; the first
five examples being 91, 259, 451, 481, and 703.

Find the sum of the first twenty-five composite values of n for which GCD(n,
10) = 1 and n − 1 is divisible by A(n).

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

open my $primes_fh, "primes 3|";
my $last_prime = int(scalar(<$primes_fh>));

my $n = 3;
my $count = 0;
my $sum = 0;

while ($count < 25)
{
    if ($n == $last_prime)
    {
        $last_prime = int(scalar(<$primes_fh>));
    }
    elsif ($n % 5)
    {
        my $A = calc_A($n);
        if (($n - 1) % $A == 0)
        {
            $count++;
            $sum += $n;
            print "Found $n ; Sum = $sum ; Count = $count\n";
        }
    }
}
continue
{
    $n += 2;
}
