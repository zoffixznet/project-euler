#!/usr/bin/perl

use strict;
use warnings;

use bytes;

no warnings 'portable';

my $factors = '';

my $sum = 1;
my $LIM = ( 64_000_000 - 1 );
for my $n ( 2 .. $LIM )
{
    vec( $factors, $n, 64 ) = 1;
}

# For $n == 1 whose sum of divisor squares are 1.
for my $n ( 2 .. $LIM )
{
    print "Reached N=$n sum = $sum\n";
    my $f = vec( $factors, $n, 64 );
    if ( $f != 1 )
    {
        # It's a composite number.
        my $s = int( sqrt($f) );
        if ( $s * $s == $f )
        {
            $sum += $n;
            print "Found $n for a total of $sum\n";
        }
    }
    else
    {
        # It's a prime.
        my $mult   = $n;
        my $factor = 1 + $mult * $mult;
        my $vec    = '';
        {
            my $prod = ( $mult << 1 );
            my $pos  = 2;

            while ( $prod < $LIM )
            {
                vec( $vec, $pos, 64 ) = $factor;
            }
            continue
            {
                $prod += $mult;
                $pos++;
            }
        }
        $mult *= $n;

        my $pos_step = $n;

        while ( $mult < $LIM )
        {
            $factor += $mult * $mult;
            my $prod = $mult;

            my $pos = $pos_step;
            while ( $prod < $LIM )
            {
                vec( $vec, $pos, 64 ) = $factor;
            }
            continue
            {
                $prod += $mult;
                $pos  += $pos_step;
            }
        }
        continue
        {
            $mult     *= $n;
            $pos_step *= $n;
        }

        my $pos = 2;
        for ( my $prod = ( $n << 1 ) ; $prod < $LIM ; $prod += $n )
        {
            vec( $factors, $prod, 64 ) *= vec( $vec, ( $pos++ ), 64 );
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
