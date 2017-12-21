#!/usr/bin/perl

use strict;
use warnings;

use integer;

# Extended gcd.
sub xgcd
{
    my ( $aa, $bb ) = @_;
    if ( $bb == 0 )
    {
        return ( 1, 0 );
    }
    else
    {
        my $q = $aa / $bb;
        my $r = $aa % $bb;
        my ( $s, $t ) = xgcd( $bb, $r );
        return ( $t, $s - $q * $t );
    }
}

open my $primes_fh, "(primes 5 1100000)|";

my $p1 = int(<$primes_fh>);
my $p2;
my $sum   = 0;
my $count = 0;
PRIMES_LOOP:
while ( $p2 = int(<$primes_fh>) )
{
    if ( $p1 > 1_000_000 )
    {
        last PRIMES_LOOP;
    }

    my $mod = $p2 - $p1;
    my $mod_delta = ( ( 1 . ( '0' x length($p1) ) ) % $p2 );

    # See:
    # http://en.wikipedia.org/wiki/Linear_congruence_theorem
    # $mod_delta * $x = $p2-$p1 (mod $p2)
    my ( $r, $s ) = xgcd( $mod_delta, $p2 );
    my $x = $r * $mod / ( $r * $mod_delta + $s * $p2 );
    if ( $x <= 0 )
    {
        $x += ( ( -$x ) / $p2 + 1 ) * $p2;
    }
    else
    {
        $x %= $p2;
    }
    my $S = ( $x . $p1 );
    $sum += $S;

    #if ((++$count) % 100 == 0)
    #{
    #    print "For (p1=$p1,p2=$p2) found $S (sum=$sum)\n";
    #}
}
continue
{
    $p1 = $p2;
}

close($primes_fh);

print "Sum = $sum\n";

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

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
