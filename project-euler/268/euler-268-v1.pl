#!/usr/bin/perl

use strict;
use warnings;

# use integer;
use bytes;

# use Math::BigInt lib => 'GMP';

use List::Util qw(min max sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @primes = map { 0 + $_ } `primes 2 100`;
my @logs   = map { log($_) } @primes;

my $L = 1_0000_0000_0000_0000;

# my $L = 1_000_000;
# my $L = 1_000;

my $LOG_L = log($L);

my $total = 0;

my $MAX_C     = ( 1 << 25 );
my $ITER      = 100_000;
my $count     = 0;
my $next_iter = $ITER;

my @factors;

for my $i ( 4 .. $#primes )
{
    my $n = $i - 3;
    $factors[$i] =
        ( ( ( $i & 0b1 ) ? (-1) : 1 ) * ( $n + 1 ) * ( $n + 2 ) * $n / 6 );
}

sub f
{
    # $i is index to start from.
    # $c is count.
    # $mul is the product
    my ( $i, $c, $mul, $mul_l ) = @_;

    # print "\@_ = @_\n";
    if ( $mul_l > $LOG_L )
    {
        return;
    }

    if ( $i == @primes )
    {
        if ( ++$count == $next_iter )
        {
            print "Reached $count/$MAX_C\n";
            $next_iter += $ITER;
        }
        if ( $c >= 4 )
        {
            my $offset = int( $L / $mul );

            $total += $factors[$c] * $offset;

         # my $sub = $c & 0x1;
         # $total += ($c == 4 ? $offset : (($sub ? -1 : 1) * ($c-1) * $offset));
        }
    }
    else
    {
        f( $i + 1, $c, $mul, $mul_l );
        f( $i + 1, $c + 1, $mul * $primes[$i], $mul_l + $logs[$i] );
    }
    return;
}

f( 0, 0, 1, 0 );

print "total = $total\n";

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
