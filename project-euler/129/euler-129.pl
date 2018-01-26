#!/usr/bin/perl

use strict;
use warnings;

=head1 ANALYSIS

A(n) < n because otherwise for R(1) .. R(n-1) there will be two identical
non-zero modulos. Let's say they are 'a' and 'b' where b > a, so
R(b) % n = R(a) % n. In that case (R(b)-R(a)) % n = 0, but then
(R(b-a) * 10^R(a)) % n = 0, and since the modulo of a power of 10 with n
cannot be 0 (because GCD(n, 10) = 1), then R(b-a) % n = 0, which demonstrates
that A(n) < n (reduction ad absurdum.).

=cut

sub calc_A
{
    my ($n) = @_;

    my $mod = 1;
    my $len = 1;

    while ($mod)
    {
        $mod = ( ( $mod * 10 + 1 ) % $n );
        $len++;
    }

    return $len;
}

print "A(7) = ",  calc_A(7),  "\n";
print "A(41) = ", calc_A(41), "\n";

my $n = 1_000_001;

N_loop:
while (1)
{
    if ( $n % 5 == 0 )
    {
        next N_loop;
    }
    my $A = calc_A($n);
    print "N = $n ; A($n) = $A\n";
    if ( $A > 1_000_000 )
    {
        print "Found n - $n\n";
        exit(0);
    }
}
continue
{
    $n += 2;
}

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
