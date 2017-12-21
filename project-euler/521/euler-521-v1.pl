#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';
use Math::GMP qw(:constant);

use List::Util qw(sum);
use List::MoreUtils qw(all);

STDOUT->autoflush(1);

my @p;

my $LIM = 1_000_000_000_000;

open my $p_fh, "primesieve 2 $LIM -p |"
    or die "Cannot open primesieve - $!";

sub get_p
{
    my ($n) = @_;

    while ( $#p < $n )
    {
        push @p, ( <$p_fh> + 0 );
    }

    return $p[$n];
}

my $START = 2;
my $INIT_SUM = ( ( ( $LIM - $START ) * ( $LIM - $START + 1 ) ) >> 1 );

print "Init\t$INIT_SUM\n";

my $mul = 1;
for my $i ( 0 .. 9 )
{
    get_p($i);

    my $p = $p[$i];

    my $new_mul = $mul * $p;

    for my $j ( 1 .. $mul )
    {
        my $check = $j * $p;

        if ( all { $check % $_ } @p[ 0 .. $i - 1 ] )
        {
            # Let's Rock and roll
            my $first = $check;

            my $last = ( $LIM / $new_mul ) * $new_mul + $check;

            if ( $last > $LIM )
            {
                $last -= $new_mul;
            }

            my $count = ( $last - $first ) / $new_mul + 1;

            my $neg_sum = -( ( ( $first + $last ) * $count ) >> 1 );
            my $pos_sum = $count * $p;

            print "NegSum[$p,$j]\t$neg_sum\nPositiveSum[$p,$j]\t$pos_sum\n";
        }
    }

    $mul = $new_mul;
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
