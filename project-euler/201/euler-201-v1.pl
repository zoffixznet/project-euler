#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

sub solve_for_set
{
    my ( $set_ref, $num_elems ) = @_;

    my @set = @$set_ref;

    my @sums = (0);
    foreach my $x (@set)
    {
        push @sums, $sums[-1] + $x;
    }

    my $top_sum = sub {
        my ($c) = @_;
        return $sums[-1] - $sums[ -( $c + 1 ) ];
    };

    my $bottom_sum = sub {
        my ( $start, $c ) = @_;

        return $sums[ $start + $c ] - $sums[$start];
    };

    # Recurse;
    my $r;

    # Number of solutions.
    my $num_sols;

    $r = sub {

        # $init_s is initial start.
        my ( $num_remain, $goal, $init_s ) = @_;

        {
            my $ts = $top_sum->($num_remain);
            if ( $ts == $goal )
            {
                $num_sols++;
                return;
            }
            elsif ( $ts < $goal )
            {
                return;
            }
        }
        for my $s ( $init_s .. @set - $num_remain - 1 )
        {
            {
                my $bs = $bottom_sum->( $s, $num_remain );
                if ( $bs == $goal )
                {
                    $num_sols++;
                    return;
                }
                elsif ( $bs > $goal )
                {
                    return;
                }
            }
            $r->( $num_remain - 1, $goal - $set[$s], $s + 1 );
            if ( $num_sols == 2 )
            {
                return;
            }
        }
    };

    my $total_sum = 0;

    my $TOP = $top_sum->($num_elems);
    for my $partial_sum ( $bottom_sum->( 0, $num_elems ) .. $TOP )
    {
        print "Evaluating $partial_sum/$TOP [total_sum = $total_sum ]\n";
        $num_sols = 0;
        $r->( $num_elems, $partial_sum, 0 );

        if ( $num_sols == 1 )
        {
            $total_sum += $partial_sum;
        }
    }

    return $total_sum;
}

# Test data.
print "Test data == ", solve_for_set( [ 1, 3, 6, 8, 10, 11 ], 3 ), "\n";
my $result = solve_for_set( [ map { $_ * $_ } 1 .. 100 ], 50 );
print "Solution == $result\n";

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
