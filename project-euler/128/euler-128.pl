#!/usr/bin/perl

use strict;
use warnings;

sub is_prime
{
    my ($n) = @_;

    if ( $n <= 1 )
    {
        return 0;
    }

    my $top = int( sqrt($n) );

    for my $i ( 2 .. $top )
    {
        if ( $n % $i == 0 )
        {
            return 0;
        }
    }

    return 1;
}

=head1 Planning

0 ; 6 ; 12 ; 18 ;  - keeps increasing by +6.

So the formula is 1 +

=head2 Middle cells cannot be PD(n) = 3

For (Side != LAST_SIDE ) and (Cell_Idx != Ring-1) and (Cell_Idx != 0)
the PD(n) cannot be 3 because
two of its distances are 1, which leaves only 4 possible prime distances, and
it is adjacent to two pairs of consecutive integers on both sides where one
distance out of each pair must be even (and so non-prime).

As a result, only corner cells (where Cell_Idx == 0) and the last cells
in the ring (where Side == LAST_SIDE && Cell_Idx == Ring - 1) can be PD(n) = 3.

=head2 Corner cells (Cell_Idx == 0) with Side != 0 cannot be PD(n) = 3

=head3 If they are on an even chain.

=head4 If they are in an even place.

Then for 12, both 4 and 26 will be even, leaving only a max PD(n) = 2.

=head4 If they are in an odd place.

Then for 10 , the neighbours of 23 - 22 and 24 will be even.

=head3 If they are on an odd chain.

=head4 If they are in an even place.

Then, for 26, both 12 and 46 will be even, giving a max PD(n) of 2.

=head4 If they are in an odd place.

Then the radial outer ring neighbour will be even, and both of their mutual
numbers will be odd. Therefore, their distances to C<n> will be even and
non-prime.

=head2 Conclusion:

The only possible PD(n) = 3 cells are either:

=over 4

=item * Cell_Idx == 0 && Side == 0

=item * Cell_Idx == Ring-1 && Side == LAST_SIDE

=back

=cut

sub get_cell_n
{
    my ( $y, $x ) = @_;

    my $d = int( sqrt( $y * $y + $x * $x ) );

    # $y is the 1,2,8,19 axis
    # $x is the 1,6,16,32... axis.

    if ( ( $x > 0 ) && ( $y > $x ) )
    {

    }
}

my $count = 1;

my $LAST_SIDE = 5;

my $ring_len        = 6;
my $ring_start      = 2;
my $prev_ring_len   = 0;
my $prev_ring_start = 1;
my $next_ring_len   = 12;
my $next_ring_start = 8;

my $ring = 1;

sub check_side_and_cell
{
    my ( $side, $cell, $n ) = @_;

    my @vicinity;

    if ( $cell != 0 )
    {
        push @vicinity, $n - 1;

        my $is_last = ( ( $cell == $ring - 1 ) && ( $side == $LAST_SIDE ) );
        if ($is_last)
        {
            push @vicinity, $ring_start;
        }
        else
        {
            push @vicinity, $n + 1;
        }

        {
            my $x = $prev_ring_start + $side * ( $ring - 1 ) + ( $cell - 1 );
            push @vicinity, $x;
            if ($is_last)
            {
                push @vicinity, $prev_ring_start;
            }
            else
            {
                push @vicinity, $x + 1;
            }
        }

        {
            my $x = $next_ring_start + $side * ( $ring + 1 ) + $cell;

            # TODO : This is wrong for the cell == 0 ; side == 0
            # item.
            push @vicinity, $x, $x + 1;
        }
    }
    else
    {
        {
            my $x = $n + 1;
            if ( $x < $next_ring_start )
            {
                push @vicinity, $x;
            }
            else
            {
                push @vicinity, $ring_start;
            }
        }
        if ( $side == 0 )
        {
            # Up and down.
            push @vicinity, ( $prev_ring_start, $next_ring_start );
            push @vicinity, ( $next_ring_start - 1 );
            push @vicinity, ( $next_ring_start + 1 );
            push @vicinity, ( $next_ring_start + $next_ring_len - 1 );
        }
        else
        {
            push @vicinity, $n - 1;
            push @vicinity, ( $prev_ring_start + ( $ring - 1 ) * $side );
            my $x = $next_ring_start + ( $ring + 1 ) * $side;
            push @vicinity, ( $x - 1 .. $x + 1 );
        }
    }

    if (0)
    {
        print "$n [Ring=$ring,Side=$side,Cell=$cell] ; Neighbours = ",
            join( ",", sort { $a <=> $b } map { abs( $n - $_ ) } @vicinity ),
            "\n";
    }
    if ( scalar( grep { is_prime( abs( $n - $_ ) ) } @vicinity ) == 3 )
    {
        $count++;
        print "Found $count: $n [Ring=$ring,Side=$side,Cell=$cell]\n";
    }
}

while ( $count < 2_000 )
{
    check_side_and_cell( 0,          0,         $ring_start );
    check_side_and_cell( $LAST_SIDE, $ring - 1, $next_ring_start - 1 );
}
continue
{
    $ring++;
    ( $prev_ring_len, $prev_ring_start, $ring_len, $ring_start ) =
        ( $ring_len, $ring_start, $next_ring_len, $next_ring_start );

    $next_ring_start += $ring_len;
    $next_ring_len   += 6;
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
