#!/usr/bin/perl

use strict;
use warnings;

use 5.014;

use Test::More;

# A 2-dimensional cache.
# $Rects_Coefficients_Cache[$rect_x][$rect_y] = { min => $min, offset => $offset};
# Formula for step is calculated at 2*$board_dim + $offset
my @Rects_Coefficients_Cache;

# A 4-dimensional cache:
# 0 - board large dim.
# 1 - board small dim.
# 2 - rect large dim.
# 3 - rect large dim.
# Each value is:
# {
#

# Cache for the boards:
# $Boards_Cache[$board_x][$board_y] = { 'num_unique' => , 'rects' => \@rects, }
# rects is:
# $rects[$rect_x][$rect_y]
my @Boards_Cache;

sub get_unique_rects
{
    # $x >= $y >= $rect_x , $rect_y
    my ( $x, $y, $rect_x, $rect_y ) = @_;

    my $board_struct = ( $Boards_Cache[$x][$y] //= +{} );

    if ( !defined( $board_struct->{num_unique} ) )
    {
        # Calculate the unique rectangles.
        $board_struct->{rects} //= [];
    }

    return $board_struct;
}

sub round_two_up
{
    my ($n) = @_;
    return ( ( $n & 0x1 ) ? ( $n + 1 ) : $n );
}

sub diag_rects
{
    my ( $xx, $yy, $rect_x, $rect_y ) = @_;

    my $x_even_start = $rect_x;
    my $x_even_end = ( ( $xx << 1 ) - $rect_y );

    if ( $x_even_end < 0 )
    {
        return;
    }

    my $y_even_end = ( ( $yy << 1 ) - ( $rect_x + $rect_y ) );

    my $x_even_end_norm = ( $x_even_end & ( ~0x1 ) );
    my $x_even_start_norm = round_two_up($x_even_start);

    my $even_count = 0;

    # For the even diagonals.
    if ( $x_even_end_norm >= $x_even_start_norm and $y_even_end >= 0 )
    {
        $even_count =
            ( ( ( ( $x_even_end_norm - $x_even_start_norm ) >> 1 ) + 1 ) *
                ( ( $y_even_end >> 1 ) + 1 ) );
    }

    my $x_odd_end =
        ( ( $x_even_end & 0x1 ) ? $x_even_end : ( $x_even_end - 1 ) );
    my $x_odd_start = ( $x_even_start | 0x1 );
    my $y_odd_start = 1;
    my $y_odd_end   = $y_even_end;

    my $odd_count = 0;
    if ( $x_odd_end >= $x_odd_start and $y_odd_end >= $y_odd_start )
    {
        $odd_count = (
            (
                ( ( ( $x_odd_end - $x_odd_start ) >> 1 ) + 1 ) *
                    ( ( ( ( $y_odd_end - $y_odd_start ) >> 1 ) + 1 ) )
            ) << 0    # ($rect_x == $rect_y ? 0 : 1)
        );
    }

    return ( $even_count, $odd_count );
}

sub get_total_rects
{
    my ( $x, $y ) = @_;

    my $sum = 0;

    foreach my $xx ( 1 .. $x )
    {
        foreach my $yy ( 1 .. $y )
        {
            $sum += $xx * $yy * ( $x - $xx + 1 ) * ( $y - $yy + 1 );
        }
    }

    my $diag_sum = 0;

    foreach my $xx ( 1 .. $x )
    {
        foreach my $yy ( 1 .. $y )
        {
            foreach my $rect_x ( 1 .. ( $xx << 1 ) )
            {
            RECT_Y:
                foreach my $rect_y ( 1 .. ( $yy << 1 ) )
                {
                    if ( my ( $even_count, $odd_count ) =
                        diag_rects( $xx, $yy, $rect_x, $rect_y ) )
                    {
                        $diag_sum += $even_count + $odd_count;
                    }
                    else
                    {
                        last RECT_Y;
                    }
                }
            }
        }
    }

    return { num_straight_rects => $sum, num_diag_rects => $diag_sum };
}

sub test_diag
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ( $xx, $yy, $diag_x, $diag_y, $want_ret_aref, $blurb ) = @_;

    my @have_ret = diag_rects( $xx, $yy, $diag_x, $diag_y );

    is_deeply( \@have_ret, $want_ret_aref, $blurb );
}

if (1)
{
    test_diag( 1, 1, 1, 1, [ 0, 0 ], "1,1,1,1" );
    test_diag( 2, 1, 1, 1, [ 1, 0 ], "1,2,1,1" );
    test_diag( 1, 2, 1, 1, [ 0, 1 ], "1,2,1,1" );
    test_diag( 3, 1, 1, 1, [ 2, 0 ], "3,1,1,1" );
    test_diag( 1, 3, 1, 1, [ 0, 2 ], "1,2,1,1" );
    test_diag( 4, 1, 1, 1, [ 3, 0 ], "3,1,1,1" );
    test_diag( 1, 4, 1, 1, [ 0, 3 ], "1,2,1,1" );
    test_diag( 2, 2, 1, 1, [ 2, 2 ], "2,2,1,1" );
    test_diag( 2, 2, 1, 2, [ 1, 1 ], "2,2,1,2" );

    done_testing();
}

my ( $x, $y ) = @ARGV;

# my $num_rects = get_rects(47, 43, 47, 43);
my $rects_struct       = get_total_rects( $x, $y );
my $num_straight_rects = $rects_struct->{num_straight_rects};
my $num_diag_rects     = $rects_struct->{num_diag_rects};

print "Straight Rects = $num_straight_rects\n";
print "Diag Rects = $num_diag_rects\n";
print "Total sum = ", $num_straight_rects + $num_diag_rects, "\n";

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
