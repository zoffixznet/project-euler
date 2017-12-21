#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(first sum);
use List::MoreUtils qw();

sub gcd
{
    my ( $n, $m ) = @_;

    if ( $m > $n )
    {
        ( $n, $m ) = ( $m, $n );
    }

    while ( $m > 0 )
    {
        ( $n, $m ) = ( $m, $n % $m );
    }

    return $n;
}

my $DEBUG = 1;

sub calc_P
{
    my ( $MIN, $MAJ ) = @_;

    my $total_count = 0;

    # For row == 1.
    $total_count += $MAJ;

    my %found;

    if ($DEBUG)
    {
        %found = ( map { $_ => 1 } ( 1 .. $MAJ ) );
    }

    foreach my $row_idx ( 2 .. $MIN )
    {
        my $max   = $row_idx * $MAJ;
        my $count = $MAJ;

        foreach my $prev_row ( 1 .. $row_idx - 1 )
        {
            my $prev_max = $prev_row * $MAJ;

            my $delta;
            if ( $prev_row == 1 )
            {
                $delta = int( $prev_max / $row_idx );
            }
            else
            {
                my $prev_row__max_divisor =
                    first { $prev_row % $_ == 0 } reverse( 1 .. $prev_row - 1 );

                # my $prev_min = ($prev_row__max_divisor * $MAJ);
                my $prev_min = ( ( $prev_row - 1 ) * $MAJ );

                # The lcm.
                my $step =
                    ( $prev_row * $row_idx / gcd( $prev_row, $row_idx ) );

                # Round up.
                # my $prev_min_pivot = ($prev_min % $step == 0 ? $prev_min
                # : ($prev_min + ($step - ($prev_min % $step)))
                # );

                my $prev_min_pivot =
                    ( $prev_min + ( $step - ( $prev_min % $step ) ) );

                # Round down.
                my $prev_max_pivot = ( $prev_max - ( $prev_max % $step ) );

                $delta = ( ( $prev_max_pivot - $prev_min_pivot ) / $step + 1 );

                for my $prev_prev ( 2 .. $prev_row - 1 )
                {

                }
            }

            if ($DEBUG)
            {
                my @expected_delta = (
                    grep { ( $found{$_} // (-1) ) == $prev_row }
                    map { $_ * $row_idx } 1 .. $MAJ
                );

                if ( $delta != @expected_delta )
                {
                    die
"Row == $row_idx ; Prev_Row == $prev_row. There are $delta whereas there should be "
                        . @expected_delta . "!\n";
                }
            }

            $count -= $delta;

            if ( $count < 0 )
            {
                die "Count is less than 0! (\$count=$count)\n";
            }
        }

        if ($DEBUG)
        {
            my @new = (
                grep { !exists( $found{$_} ) }
                map  { $row_idx * $_ } 1 .. $MAJ
            );

            if ( @new != $count )
            {
                die "Row == $row_idx. There are $count whereas there should be "
                    . @new . "!\n";
            }

            %found = ( %found, map { $_ => $row_idx } @new );
        }

        $total_count += $count;
    }

    return $total_count;
}

sub my_test
{
    my ( $MIN, $MAJ, $expected ) = @_;

    my $got = calc_P( $MIN, $MAJ );

    print "P($MIN, $MAJ) = $got (should be $expected)\n";
}

# my_test(3, 4, 8);
my_test( 64, 64,  1263 );
my_test( 12, 345, 1998 );
my_test( 32, ( ( '1' . ( '0' x 15 ) ) + 0 ), 13826382602124302 );

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
