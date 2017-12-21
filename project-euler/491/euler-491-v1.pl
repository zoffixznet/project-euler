#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(product sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @factorials = (1);
for my $n ( 1 .. 10 )
{
    push @factorials, $factorials[-1] * $n;
}

my ($MAX_DIGIT) = @ARGV;

my $num_half_digits = $MAX_DIGIT + 1;
my $num_digits      = $num_half_digits * 2;

my $count = 0;

my $EXPECTED_SUM = ( ( ( 0 + $MAX_DIGIT ) * $num_half_digits ) >> 1 );
for my $leading_digit ( 1 .. $MAX_DIGIT )
{
    my @digits_counts = ( (2) x $num_half_digits );

    $digits_counts[$leading_digit]--;

    my $rec;

    $rec = sub {
        my ( $start_from, $num_remaining, $digits_c, $sum_left ) = @_;

        if ( $num_remaining == 0 )
        {
            if ( $sum_left % 11 == 0 )
            {
                $count +=
                    $factorials[ $num_half_digits - 1 ] *
                    $factorials[$num_half_digits] /
                    product(
                    map {
                        $factorials[ $digits_c->[$_] ] *
                            $factorials[ $digits_counts[$_] - $digits_c->[$_] ]
                    } keys(@digits_counts)
                    );
            }

            return;
        }

        if ( $start_from <= $MAX_DIGIT )
        {
        C:
            for my $c ( 0 .. $digits_c->[$start_from] )
            {
                if ( $num_remaining < $c )
                {
                    last C;
                }
                my @new = @$digits_c;
                $new[$start_from] -= $c;
                $rec->(
                    $start_from + 1,
                    $num_remaining - $c,
                    ( \@new ), $sum_left - ( $start_from * $c )
                );
            }
        }

        return;
    };

    $rec->(
        0, $num_half_digits - 1,
        \@digits_counts, ( $EXPECTED_SUM - $leading_digit )
    );
}

print "Count = $count\n";

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
