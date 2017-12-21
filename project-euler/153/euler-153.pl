#!/usr/bin/perl

use strict;
use warnings;
use integer;
use bytes;

use List::Util qw(min sum);
use List::MoreUtils qw();

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m > $n )
    {
        ( $n, $m ) = ( $m, $n );
    }

    while ( $m > 0 )
    {
        ( $n, $m ) = ( $m, $n % $m );
    }

    return $n;
}

sub calc_sum
{
    my ($MAX) = @_;

    my $ret = 0;

    my $MAX_SQ = $MAX * $MAX;
    foreach my $aa ( 1 .. $MAX )
    {
        print "a=$aa\n";

        my $s = sub {
            my ($bb) = @_;

            # print "a=$aa b=$bb\n";

            # Question: when is ($cc*$bb/$aa) an integer?
            #
            # Answer: when $cc*$bb mod $aa == 0
            # That happens when $cc is a product of $aa/gcd($aa,$bb)

            my $cc_step = $aa / gcd( $bb, $aa );

            my $max_cc = min( $aa, $MAX / ( $aa * ( 1 + ( $bb / $aa )**2 ) ), );

            my $cc_num_steps = int( ( $max_cc - 1 ) / $cc_step );

            # Sum of $aa+$cc_step + $aa + 2*$cc_step + $aa + 3 * $cc_step
            # up to $aa + $cc_step*($cc_num_steps)
            my $cc = $cc_step * ( $cc_num_steps + 1 );

            # die if ($cc != $max_cc);

            return $cc_num_steps * ( $aa + ( $cc >> 1 ) ) + (
                  ( $cc == $max_cc )
                ? ( $aa + ( ( $cc == $aa ) ? 0 : $cc ) )
                : 0
            );
        };

        $ret += $s->(0);

        my $d = 0;
        foreach my $bb ( 1 .. int( sqrt( $MAX_SQ - $aa * $aa ) ) )
        {
            $d += $s->($bb);
        }
        $ret += $d << 1;
    }

    return $ret;
}

print calc_sum( shift(@ARGV) ), "\n";

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
