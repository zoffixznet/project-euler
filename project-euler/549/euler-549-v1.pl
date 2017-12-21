#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

STDOUT->autoflush(1);

use List::Util qw/max min/;

my $MAX = 100_000_000;

# my $MAX = 100;
my @primes = `primesieve -p 2 $MAX`;
chomp(@primes);

my $sum     = 0;
my $start   = 2;
my $SEGMENT = 1_000_000;

sub _calc_end
{
    return min( $start + $SEGMENT, $MAX );
}
my $end = _calc_end();

while ( $start <= $MAX )
{
    print "Evaluating $start .. $end\n";
    my @factors;

PRIMES:
    foreach my $p (@primes)
    {
        if ( $p > $end )
        {
            last PRIMES;
        }
        my $p_mul = $p;
        while ( $p_mul <= $end )
        {
            my $s = ( $start / $p_mul ) * $p_mul;
            if ( $s < $start )
            {
                $s += $p_mul;
            }
            while ( $s <= $end )
            {
                $factors[ $s - $start ]{$p}++;
            }
            continue
            {
                $s += $p_mul;
            }
        }
        continue
        {
            $p_mul *= $p;
        }
    }

    for my $n ( $start .. $end )
    {
        my $f   = $factors[ $n - $start ];
        my $val = 0;

        my @k = keys %$f;

        foreach my $p (@k)
        {
            my $e = $f->{$p};
            my $p_val;
            if ( $e == 1 )
            {
                $p_val = $p;
            }
            else
            {
                my $p_mul = $p;
                my $count = 1;
                while ( $count < $e )
                {
                    $p_mul += $p;
                    my $x = $p_mul;
                    while ( ( $x % $p ) == 0 )
                    {
                        $count++;
                        $x /= $p;
                    }
                }
                $p_val = $p_mul;
            }
            $val = max( $val, $p_val );
        }
        $sum += $val;
    }
}
continue
{
    $start = $end + 1;
    $end   = _calc_end();
}

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
