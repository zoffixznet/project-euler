#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

STDOUT->autoflush(1);

use List::Util qw/max min/;

my $MAX = 100_000_000;

# my $MAX = 100;
my $buf = '';

my @primes = `primesieve -p 2 $MAX`;
chomp(@primes);

foreach my $p (@primes)
{
    print "Doing p = $p\n";
    my @powers = ();
    {
        my $pow = $p;
        while ( $pow <= $MAX )
        {
            push @powers, [ $pow, $pow ];
            $pow *= $p;
        }
    }

    $powers[0][1] += $powers[0][0];
    my $this_e = 1;
    my $prev_e = 0;
    my $mul    = $p;

    foreach my $e ( 1 .. @powers )
    {
        if ( $e == $prev_e + 1 )
        {
            my $pow = $powers[ $e - 1 ][0];
            my $i   = $pow;
            while ( $i <= $MAX )
            {
                if ( vec( $buf, $i, 32 ) < $mul )
                {
                    vec( $buf, $i, 32 ) = $mul;
                }
            }
            continue
            {
                $i += $pow;
            }
        }
    }
    continue
    {
        if ( $e == $this_e )
        {
            $mul += $p;
            $prev_e = $this_e;
        INC_THIS_E:
            foreach my $p_r (@powers)
            {
                if ( $p_r->[1] == $mul )
                {
                    $this_e++;
                    $p_r->[1] += $p_r->[0];
                }
                else
                {
                    last INC_THIS_E;
                }
            }
        }
    }
}

my $sum = 0;
foreach my $i ( 2 .. $MAX )
{
    $sum += vec( $buf, $i, 32 );
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
