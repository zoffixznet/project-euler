#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum max min);
use List::MoreUtils qw();

use integer;

use Math::Prime::FastSieve;

my $DELTA = 1_000_000;

my $MAX = (1 << 50);

sub gen_prime_iter
{
    my $start = 1;
    my $sieve = Math::Prime::FastSieve->new;

    my $primes = [];

    return
    sub
    {
        if (! @$primes)
        {
            my $end = min($MAX, $start + $DELTA);
            my $was_end_reached = ($start == $end);

            if ($was_end_reached)
            {
                return undef;
            }

            $primes = $sieve->ranged_primes($start, $end);
            $start = $end;
        }

        return shift(@$primes);
    };
}


