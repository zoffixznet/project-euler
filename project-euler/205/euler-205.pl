#!/usr/bin/perl

use strict;
use warnings;

my %counts = ( 4 => [], 6 => [] );
my %totals = ( 4 => 0, 6 => 0 );

sub recurse
{
    my ( $num_sides, $sum_so_far, $remaining_dice ) = @_;

    if ( $remaining_dice == 0 )
    {
        $counts{$num_sides}[$sum_so_far]++;
        $totals{$num_sides}++;
    }
    else
    {
        for my $i ( 1 .. $num_sides )
        {
            recurse( $num_sides, $sum_so_far + $i, $remaining_dice - 1 );
        }
    }
    return;
}

recurse( 4, 0, 9 );
recurse( 6, 0, 6 );

my $OTHER      = 6;
my $other_sums = [];
{
    my $s = 0;
    push @$other_sums, $s;
    foreach my $count ( @{ $counts{$OTHER} } )
    {
        push @$other_sums, ( $s += ( $count // 0 ) );
    }
}

my $PIVOT = 4;

my $pivot_counts = $counts{$PIVOT};

my $prob_sum = 0;
foreach my $score ( keys(@$pivot_counts) )
{
    my $prob = ( $pivot_counts->[$score] // 0 );
    if ( $prob > 0 )
    {
        $prob_sum += $prob * ( $other_sums->[$score] );
    }
}

printf "ProbSum = %i ; Prob = %.7f\n", $prob_sum,
    ( $prob_sum / ( $totals{$PIVOT} * $totals{$OTHER} ) );

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
