#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum);

sub is_prime
{
    my ($n) = @_;

    if ($n <= 1)
    {
        return 0;
    }

    my $top = int(sqrt($n));

    for my $i (2 .. $top)
    {
        if ($n % $i == 0)
        {
            return 0;
        }
    }

    return 1;
}

my @trunc_primes = ();

N_LOOP:
for(my $n = 11; @trunc_primes < 11 ; $n += 2)
{
    foreach my $i (1 .. length($n))
    {
        if (is_prime(substr($n, 0, $i))
                &&
            is_prime(substr($n, -$i))
        )
        {
            # Do nothing
        }
        else
        {
            next N_LOOP;
        }
    }
    push @trunc_primes, $n;
    print "Found " . join(",", @trunc_primes) . "\n";
    print "Sum = " . sum(@trunc_primes) . "\n";
}
