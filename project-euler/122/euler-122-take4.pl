#!/usr/bin/perl

use strict;
use warnings;

use integer;

use List::MoreUtils qw(uniq);
use List::Util qw(min);
use List::UtilsBy qw(min_by);
use IO::Handle;

STDOUT->autoflush(1);

my $comb1 = '';
vec( $comb1, 1, 1 ) = 1;

my @compositions = ( undef, [$comb1], );

my $limit = 200;

my $power_of_2 = 2;

while ( $power_of_2 < $limit )
{
    my $v = $compositions[ $power_of_2 / 2 ][0];

    vec( $v, $power_of_2, 1 ) = 1;
    push @{ $compositions[$power_of_2] }, $v;

    my $less_sig = $power_of_2;
    $less_sig /= 2;

    while ( $less_sig >= 1 )
    {
        my $v2 = $v;
        vec( $v2, $power_of_2 + $less_sig, 1 ) = 1;
        push @{ $compositions[ $power_of_2 + $less_sig ] }, $v2;
    }
    continue
    {
        $less_sig /= 2;
    }
}
continue
{
    $power_of_2 *= 2;
}

{
    my $n = 7;

    my $v = '';
    vec( $v, 1, 1 ) = 1;
    vec( $v, 2, 1 ) = 1;
    vec( $v, 4, 1 ) = 1;
    vec( $v, 6, 1 ) = 1;
    vec( $v, 7, 1 ) = 1;

    push @{ $compositions[$n] }, ( my $s = $v );

    $n *= 2;
    while ( $n < $limit )
    {
        vec( $v, $n, 1 ) = 1;
        push @{ $compositions[$n] }, ( my $s = $v );
    }
    continue
    {
        $n *= 2;
    }
}
my $sum = 0;

N_LOOP:
foreach my $n ( 1 .. 200 )
{
    if ( !defined( $compositions[$n] ) )
    {
        print "${n}: Unavailable\n";
        next N_LOOP;
    }
    my $optimal_comb =
        min_by { unpack( "b*", $_ ) =~ tr/1/1/ } @{ $compositions[$n] };

    my $comb = unpack( "b*", $optimal_comb );
    my $result = -1 + $comb =~ tr/1/1/;
    print "${n}: $result ($comb)\n";

    $sum += $result;
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
