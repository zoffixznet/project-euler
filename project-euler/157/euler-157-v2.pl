#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %l = (
    ''          => 1,
    '0'         => 2,
    '00'        => 3,
    '000'       => 4,
    '0000'      => 5,
    '00000'     => 6,
    '000000'    => 7,
    '0000000'   => 8,
    '00000000'  => 9,
    '000000000' => 9,
);

my $base = 1_000_000_000;
my $t;
for my $p ( 1 .. ( $base << 2 ) )
{
    # Start
    my $S = $base / $p;

    # Limit
    my $L = ( $S << 1 );

    # Count;
    my $c = 0;

    # 1/B numerator / denom
    my $Bd = $base * $S;
    my $Bn = $p * $S - $base;

    if ( $Bn > 0 )
    {
        if ( $Bd % $Bn == 0 )
        {
            $c++;
            print "A=$S c++\n";
        }
    }

    $Bd += $base;
    $Bn += $p;
A:
    for my $A ( $S + 1 .. $L )
    {
        if ( $Bd % $Bn == 0 )
        {
            $c++;
            print "A=$A c++\n";
        }
    }
    continue
    {
        $Bd += $base;
        $Bn += $p;
    }

    # Zeros
    my ($z) = ( $p =~ /(0*)\z/ );
    $t += $c * $l{$z};
    print "p=$p t=$t\n";
}

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
