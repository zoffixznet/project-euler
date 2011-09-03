#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;

STDOUT->autoflush(1);
use Math::BigInt lib => 'GMP', ':constant';

=head1 DESCRIPTION

There are some prime values, p, for which there exists a positive integer, n,
such that the expression n^3 + n^2p is a perfect cube.

For example, when p = 19, 8^3 + 8^2×19 = 123.

What is perhaps most surprising is that for each prime with this property the
value of n is unique, and there are only four such primes below one-hundred.

How many primes below one million have this remarkable property?

=head1 ANALYSIS

n^3+n^2*p = n^2(n+p).

Can n > p? The number is n^2(n+p), where n+p is co-prime to n (WRONG! n can
may be divisible by p). So n^2 must
be a perfect cube and so does n+p. In order for n^2 to be a cube, so does n.
But the difference between two cubes cannot be a prime number because:
a^3 – b^3 = (a – b)(a^2 + ab + b^2). Ergo: n <= p.

n != p because otherwise the number will be 2n^3 which cannot be a cube.
So n < p.

=cut

open my $primes_fh, "primes 2 1000000|"
    or die "Cannot open primes program!";

my $found_count = 0;

while (my $prime = <$primes_fh>)
{
    chomp($prime);
    print "Reached $prime\n";
    N_LOOP:
    for my $n (1 .. $prime*3)
    {
        my $x = Math::BigInt->new($n*$n*($n+$prime));
        
        if ($x->copy->broot(3)->bpow(3) == $x)
        {
            $found_count++;
            print "Found $prime. Total: $found_count\n";
            last N_LOOP;
        }
    }
}
