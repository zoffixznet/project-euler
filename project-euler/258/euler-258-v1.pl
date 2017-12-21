#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my $BASE = 20092010;
my $LEN  = 2000;

# Penultimate len.
my $PL = $LEN - 1;

package Mat;

my $ORIG  = 0;
my $TRANS = 1;

sub new
{
    my $o = \( my $foo = '' );
    my $t = \( my $bar = '' );

    my ( $class, $cb ) = @_;

    # The cell index
    my $ci = 0;
    for my $row ( 0 .. $PL )
    {
        my $ti = $row;
        for my $col ( 0 .. $PL )
        {
            vec( $$o, $ci++, 32 ) = vec( $$t, $ti, 32 ) = $cb->( $row, $col );
        }
        continue
        {
            $ti += $LEN;
        }
    }
    return bless [ $o, $t ], $class;
}

sub mul
{
    my ( $m_base, $n_base ) = @_;

    my $m = $m_base->[$ORIG];
    my $n = $n_base->[$TRANS];

    my $mi = -$LEN;
    my $ni;
    return Mat->new(
        sub {
            my ( $r, $c ) = @_;

            if ( $c == 0 )
            {
                $mi += $LEN;
                $ni = 0;
            }
            my $sum = 0;
            for my $i ( 0 .. $PL )
            {
                ( $sum += vec( $$m, $mi + $i, 32 ) * vec( $$n, $ni++, 32 ) ) %=
                    $BASE;
            }

            return $sum;
        }
    );
}

package main;

my $ONE = Mat->new(
    sub {
        my ( $r, $c ) = @_;
        return (
            (
                       ( ( $r == $PL ) and ( $c <= 1 ) )
                    or ( ( $r < $PL )  and ( $r + 1 == $c ) )
            ) ? 1 : 0
        );
    },
);

sub power
{
    my ($n) = @_;

    if ( $n == 1 )
    {
        return $ONE;
    }
    else
    {
        my $rec = power( $n >> 1 );
        print "After rec $n\n";
        my $ret = $rec->mul($rec);
        print "After mul $n\n";
        return ( ( $n & 0x1 ) ? $ret->mul($ONE) : $ret );
    }
}

my $p = power(1_000_000_000_000_000_000);

my $sum = 0;

my $o = $p->[$ORIG];
for my $col ( 0 .. $PL )
{
    ( $sum += vec( $$o, $col, 32 ) ) %= $BASE;
}

print "Result = $sum\n";

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
