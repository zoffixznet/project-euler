#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $counts = "";

# Cache.
my %C = ( 1 => 1 );

sub chain_len
{
    my ($n) = @_;

    return ( $C{$n} //= ( 1 + chain_len( vec( $counts, $n, 32 ) ) ) );
}

my $MAX = 40_000_000;

foreach my $i ( 2 .. $MAX - 1 )
{
    vec( $counts, $i, 32 ) = $i - 1;
}
print "Initialized Array\n";

my $min_n;
my $min_expr = 1_000_000;

my $l = ( $MAX >> 1 );
foreach my $d ( 2 .. $l )
{
    print "d=$d\n" if ( $d % 1_000 == 0 );
    my $totient = vec( $counts, $d, 32 );

    my $m = $d << 1;
    while ( $m < $MAX )
    {
        vec( $counts, $m, 32 ) -= $totient;
    }
    continue
    {
        $m += $d;
    }
}

my $LEN = 25;
open my $fh, "primes 2 $MAX|";
while ( my $p = <$fh> )
{
    chomp($p);
    printf "%d L=%d\n", $p, chain_len( $p, 1 );
}
close($fh);

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
