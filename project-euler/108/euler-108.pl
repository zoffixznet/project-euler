#!/usr/bin/perl

use strict;
use warnings;

=head1 ANALYSIS

ny + nx = xy

n (x+y) = xy

n = xy / (x+y)

x,y > n

1/y = 1/n-1/x = (x-n)/nx

y = nx/(x-n)

If t = x-n ; x = t + n

y = n*(t+n) / t = n + [ n^2 / t ]

t \in [1 .. n]

If n = p1^e1 * p2^e2 * p3^e3 ....

Then the number of t's is (2*e1+1)*(2*e2+1)*(2*e3+1)*(2*e4+1)/2

=cut

=begin Removed

use integer;

for (my $n = 1_000; ;$n++)
{
    my $count = 0;
    my $n_sq = $n * $n;

    for my $t (1 .. $n)
    {
        if (! ($n_sq % $t))
        {
            $count++;
        }
    }
    print "Reached $n [$count]\n";
    if ($count > 1_000)
    {
        print "N = $n\n";
        exit(0);
    }
}

=end Removed

=cut

use Math::GMP ':constant';

use Heap::Fibonacci;
use Heap::Elem::Num qw(NumElem);

use List::Util qw(reduce);

my $heap = Heap::Fibonacci->new;

my @primes = `primes 2 | head -1001`;
chomp(@primes);

my %decomposition = ( '1' => [] );

$heap->add( NumElem(1) );

while ( my $elem = $heap->extract_top )
{
    my $n = $elem->val;

    my $composition = $decomposition{"$n"};
    if ( ( reduce { $a * $b } 1, map { $_ * 2 + 1 } @$composition ) > 1_999 )
    {
        print "Found $n\n";
        exit(0);
    }
    else
    {
        foreach my $idx (
            0 .. (
                  ( @$composition == @primes )
                ? ($#$composition)
                : ( $#$composition + 1 )
            )
            )
        {
            my @new = @$composition;
            $new[$idx]++;
            my $new_n =
                reduce { $a * $b } 1,
                map { $primes[$_]**$new[$_] } ( 0 .. $#new );
            if ( !exists( $decomposition{"$new_n"} ) )
            {
                $decomposition{"$new_n"} = \@new;
                $heap->add( NumElem($new_n) );
            }
        }
    }
}

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
