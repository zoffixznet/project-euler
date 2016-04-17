#!/usr/bin/perl

use strict;
use warnings;

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

use integer;
use IO::Handle;
use List::Util qw(max);

STDOUT->autoflush(1);

my $sum = 0;

for my $A (3 .. 1_000)
{
    my $r_max = 2;

    foreach my $n (grep { $_ % 2 } (0 .. 2*$A))
    {
        my $r = ((2 * $A * $n) % ($A*$A));
        $r_max = max($r_max, $r);
    }
    print "$A : $r_max\n";
    $sum += $r_max;
}

print "Sum = $sum\n";
