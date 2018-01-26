#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

sub factorize
{
    my ($n) = @_;
    my @ret;

    my $factor = 2;
    while ( $n > 1 )
    {
        if ( $n % $factor == 0 )
        {
            push @ret, $factor;
            $n /= $factor;
        }
        else
        {
            $factor++;
        }
    }
    return \@ret;
}

# l = len or logarithm.
# n = a promise for the number.
my @factors = (
    +{
        l => 2,
        n => sub { return 11; }
    },
    (
        map {
            my $e = $_;
            +{
                l => ( ( 2**$e ) + 1 ),
                n => sub { return 10**( 2**$e ) + 1; },
                }
        } ( 1 .. 9 )
    ),
    (
        map {
            my $e = $_;
            my $ten_e = ( 2**9 ) * ( 5**$e );
            +{
                l => ( 4 * $ten_e + 1 ),
                n => sub {
                    my $x = ( 10**$ten_e );
                    return 1 + $x + ( $x**2 ) + ( $x**3 ) + ( $x**4 );
                },
                }
        } ( 1 .. 9 )
    ),
);

@factors = ( sort { $a->{l} <=> $b->{l} } @factors );

my @primes;

my $LIMIT = 40;

NON_P_FACTORS:
foreach my $fact (@factors)
{
    print "$fact->{l}\n";
    my $n = $fact->{n}->();

    print "N = $n\n";
    my $l = <STDIN>;
    next NON_P_FACTORS;

    push @primes, @{ factorize($n) };

    @primes = sort { $a <=> $b } @primes;

    if ( @primes > $LIMIT )
    {
        splice( @primes, $LIMIT );
    }

    if ( @primes == $LIMIT )
    {
        my $s = 0;

        foreach my $p (@primes)
        {
            $s += $p;
        }
        print "Primes [", join( ',', @primes ), "]\n";
        print "Sum = $s\n";
    }
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
