#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt 'lib' => 'GMP', ':constant';

use List::Util qw(reduce min);

my @divisors;

foreach my $power_of_2 ( 0 .. 9 )
{
    foreach my $power_of_5 ( 0 .. 9 )
    {
        my $num_digits = 2**$power_of_2 * 5**$power_of_5;
        push @divisors,
            +{
            l => $num_digits + 1,
            n => sub { return ( "1" . "0" x ( $num_digits - 1 ) . "1" ) },
            };

        push @divisors,
            +{
            l => $num_digits * 4 + 1,
            n =>
                sub { return ( ( "1" . "0" x ( $num_digits - 1 ) ) x 4 . "1" ) }
            ,
            };
    }
}

@divisors = sort { $a->{l} <=> $b->{l} } @divisors;

my %factors;
foreach my $div (@divisors)
{
    my $n = $div->{n}->();

    print "Checking $n\n";
    my $factor_string = `factor "$n"`;

    $factor_string =~ s{\A[^:]*:\s*}{}ms;

    foreach my $f ( split( /\s+/, $factor_string ) )
    {
        $factors{$f}++;
    }
    my @factors_sorted = sort { $a <=> $b } keys(%factors);
    print "Num found factors: ", scalar(@factors_sorted), "\n";
    print "Factors == @factors_sorted\n";
    print "Sum first 40:",
        (
        reduce { $a + $b } 0,
        0, @factors_sorted[ 0 .. min( $#factors_sorted .. 39 ) ]
        ),
        "\n";
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
