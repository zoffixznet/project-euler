#!/usr/bin/perl

use strict;
use warnings;

=head1 DESCRIPTION

Let p_(n) be the nth prime: 2, 3, 5, 7, 11, ..., and let r be the remainder
when (p_(n)−1)^(n) + (p_(n)+1)^(n) is divided by p_(n)^(2).

For example, when n = 3, p_(3) = 5, and 4^(3) + 6^(3) = 280 ≡ 5 mod 25.

The least value of n for which the remainder first exceeds 10^(9) is 7037.

Find the least value of n for which the remainder first exceeds 10^(10).

=head1 PLANNING

(a-1)^(n) = (a+(-1))^n = Sigma_{k=0}^{n} { nCr(n,k) * a^k * (-1)^(n-k) }
(a+1)^(n) = (a+(-1))^n = Sigma_{k=0}^{n} { nCr(n,k) * a^k }

Since a^2, a^3 , a^4 etc. are evenly divisable by a^2 we get that
the modulo of the sum is:

1^n + (-1)^n + n * a + (-1)^(n-1) * n * a =

If n mod 2 = 0 we get:

2

Else we get:

2 * n * a

Now if n = a * x + n' where x is an integer we get

2 * (a*x+n') * a = 2 * a^2*x + 2 * n' * a

Which means, we only need to consider up to n = a-1. However, we can have
different modulos in the odd numbers up to 2*a, so we should go over them too.

=cut

use strict;
use warnings;

# use Math::BigInt lib=>"GMP", ":constant";
use integer;
use IO::Handle;

STDOUT->autoflush(1);

my $n = 0;
open my $primes_fh, "primes 2|"
    or die "Cannot open the primes filehandle.";

PRIMES:
while (my $p = <$primes_fh>)
{
    if (! ((++$n) & 0x1))
    {
        # Always 2.
        next PRIMES;
    }
    chomp($p);

    if (((2 * $n * $p) % ($p * $p)) > 10_000_000_000)
    {
        print "Found n = $n p = $p\n";
        last PRIMES;
    }
}
close($primes_fh);

