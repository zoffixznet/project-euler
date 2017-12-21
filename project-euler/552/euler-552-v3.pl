#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP;

use Math::BigInt lib => 'GMP';    #, ':constant';

use List::Util qw(reduce sum);
use List::MoreUtils qw(all);

use Math::ModInt qw(mod);
use Math::ModInt::ChineseRemainder qw(cr_combine cr_extract);

my $MAX = 300000;

# p is the primes
my @p = `primes 2 $MAX`;
chomp(@p);

STDOUT->autoflush(1);

my $sum = 0;
my $m = mod( 1, 2 );

# s = search through.
my $s = [@p];
shift @p;
while ( my ( $i, $P ) = each @p )
{
    print "Reached i=$i\n";
    $m = cr_combine( $m, mod( $i + 2, Math::BigInt->new($P) ) );
    my $A = $m->residue;

    my @n;
    while ( $s->[0] <= $P )
    {
        shift @$s;
    }
    foreach my $p (@$s)
    {
        if ( $A % $p == 0 )
        {
            $sum += $p;
            print "Found p=$p sum=$sum\n";
        }
        else
        {
            push @n, $p;
        }
    }
    $s = \@n;
}

print "Sum == $sum\n";

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
