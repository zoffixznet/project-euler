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

for my $A ( 3 .. 1_000 )
{
    my $r_max = 2;

    foreach my $n ( grep { $_ % 2 } ( 0 .. 2 * $A ) )
    {
        my $r = ( ( 2 * $A * $n ) % ( $A * $A ) );
        $r_max = max( $r_max, $r );
    }
    print "$A : $r_max\n";
    $sum += $r_max;
}

print "Sum = $sum\n";

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
