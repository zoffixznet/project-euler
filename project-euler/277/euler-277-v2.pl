#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use Math::GMP;

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub base3
{
    my $i = shift;

    if ( $i == 0 )
    {
        return '';
    }

    return base3( $i / 3 ) . ( $i % 3 );
}

my $a1 = Math::GMP->new('1000000000000003');
my @SEQ = map { { U => 1, D => 0, d => 2 }->{$_} } split //,
    'UDDDUdddDDUDDddDdDddDDUDDdUUDd';
my $max_i     = -1;
my $max_i__a1 = $a1 + 0;

sub get_len
{
    my $x = shift;

    for my $i ( keys(@SEQ) )
    {
        my $move = $SEQ[$i];
        my $m    = $x % 3;
        if ( $move == $m )
        {
            if ( $i > $max_i )
            {
                print "Reached $i at $a1 [delta="
                    . base3( $a1 - $max_i__a1 ) . "]\n";
                $max_i     = $i;
                $max_i__a1 = $a1 + 0;
            }
            $x =
                  ( $move == 0 ) ? ( $x / 3 )
                : ( $move == 1 ) ? ( 4 * $x + 2 ) / 3
                :                  ( 2 * $x - 1 ) / 3;
        }
        else
        {
            return ( $i - 1 );
        }
    }
    return scalar @SEQ;
}

MAIN:
while (1)
{
    my $x = $a1 + 0;

    my $l = get_len( $x + 0 );

    if ( $l == @SEQ )
    {
        print "Result == $x\n";
        last MAIN;
    }
    my $next_a1 = sub {
        for my $pow3 ( 1 .. 200 )
        {
            for my $d ( 1 .. 2 )
            {
                my $pivot = $x + $d * Math::GMP->new('3')**$pow3;
                if ( get_len($pivot) > $l )
                {
                    return $pivot;
                }
            }
        }
        }
        ->();

    $a1 = $next_a1;
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
