#!/usr/bin/perl

use strict;
use warnings;
use bigint;
use autodie;

use List::Util qw/ min max /;

my $bin_low_s  = '100110001001011001110110';
my $bin_high_s = $bin_low_s =~ s#0#1#gr;

my $bin_low     = eval "0b$bin_low_s";
my $bin_high    = eval "0b$bin_high_s";
my $bin_offsets = $bin_high + 1 - $bin_low;

my $f5_low  = $bin_low;
my $f5_high = 1;
while ( $f5_high < $f5_low )
{
    $f5_high *= 5;
}

$f5_high--;
my $f5_offsets = $f5_high + 1 - $f5_low;

my @state = (
    [ $bin_low, $bin_high, $bin_high + 1 ],
    [ $f5_low,  $f5_high,  $f5_high + 1 ]
);

sub adv
{
    my $i = shift;
    print "Adv $i\n";
    for my $j ( 0 .. 1 )
    {
        $state[$i][$j] += $state[$i][2];
    }
    return;
}

while (1)
{
    while ( $state[0][1] < $state[1][0] )
    {
        adv(0);
    }
    while ( $state[1][1] < $state[0][0] )
    {
        adv(1);
    }

    if ( $state[0][0] >= $state[1][0] and $state[0][0] <= $state[1][1] )
    {
        print "Overlap $state[0][0] -> ", min( $state[1][1], $state[0][1] ),
            "\n";
        adv(0);
    }
    elsif ( $state[1][0] >= $state[0][0] and $state[1][0] <= $state[0][1] )
    {
        print "Overlap $state[1][0] -> ", min( $state[1][1], $state[0][1] ),
            "\n";
        adv(1);
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
