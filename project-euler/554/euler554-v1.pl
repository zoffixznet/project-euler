#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

no warnings 'recursion';

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @OFFSETS = ( [ 0, 0 ], [ 0, 1 ], [ 1, 0 ], [ 1, 1 ] );

my @ATTACKS;
my @A;

foreach my $x ( -2 .. 2 )
{
    foreach my $y ( -2 .. 2 )
    {
        if ( abs($x) + abs($y) == 3
            or ( abs($x) <= 1 ) && ( abs($y) <= 1 ) )
        {
            push @ATTACKS, [ $x, $y ];
            $A[ $x + 6 ][ $y + 6 ] = 1;
        }
    }
}

my %A = ( map { ( join ',', @$_ ) => 1 } @ATTACKS );

sub calc_C
{
    my ($n) = @_;

    my $cb;
    my $ret = 0;

    my @p = [ (undef) x ( $n * $n ) ];

    $cb = sub {
        my ( $x, $y, $i ) = @_;

        my $base_x = ( $x << 1 );
        my $base_y = ( $y << 1 );

    NEW:
        foreach my $new (@OFFSETS)
        {
            my $nx = $base_x + $new->[0];
            my $ny = $base_y + $new->[1];

            my $check = sub {
                my ($off) = @_;
                my $cent = $p[ $i - $off ];
                return $A[ $cent->[0] - $nx + 6 ][ $cent->[1] - $ny + 6 ];
            };

            if (   $x > 0 && $check->(1)
                or $y > 0 && $check->($n)
                or $x > 0 && $y > 0 && $check->( $n + 1 ) )
            {
                next NEW;
            }

            $p[$i] = [ $nx, $ny ];

            # Move to the next.
            if ( $x + 1 == $n )
            {
                if ( $y + 1 == $n )
                {
                    ++$ret;
                    if (1)
                    {
                        my @board = ( map { [ (' ') x ( $n << 1 ) ] }
                                1 .. ( $n << 1 ) );
                        foreach my $p (@p)
                        {
                            $board[ $p->[1] ][ $p->[0] ] = '*';
                        }
                        print '-' x ( ( $n + 1 ) << 1 ), "\n";
                        foreach my $row (@board)
                        {
                            print '|' . ( join '', @$row ) . "|\n";
                        }
                        print '-' x ( ( $n + 1 ) << 1 ), "\n";
                    }

                    # printf "Ret = %d\n", ++$ret;
                }
                else
                {
                    $cb->( 0, $y + 1, $i + 1 );
                }
            }
            else
            {
                $cb->( $x + 1, $y, $i + 1 );
            }
        }
    };

    $cb->( 0, 0, 0 );

    $cb = undef;

    return $ret;
}

sub print_C
{
    my ($n) = @_;

    printf "C(%d) = %d\n", $n, calc_C($n);
}

print_C(1);
print_C(2);
print_C(3);
print_C(4);
print_C(10);

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
