#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %sums;

open my $p_fh, 'primes 2 5000|' or die "Foo - $!";
my $sum = 0;
while ( my $p = <$p_fh> )
{
    chomp($p);
    print "Reached p = $p\n";
    $sum += $p;
    foreach my $k ( reverse sort { $a <=> $b } keys %sums )
    {
        ( $sums{ $k + $p } //= Math::GMP->new(0) ) += $sums{$k};
    }
    ( $sums{$p} //= Math::GMP->new(0) )++;
}
close($p_fh);

my $total = Math::GMP->new(0);
open my $sum_fh, "primes 2 $sum |" or die "Bar - $!";

while ( my $s = <$sum_fh> )
{
    chomp($s);
    if ( exists( $sums{$s} ) )
    {
        $total += $sums{$s};
    }
}
close($sum_fh);

print "Ret = $total ; LastDigits = ", substr( "$total", -16 ), "\n";

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
