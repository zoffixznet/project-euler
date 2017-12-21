#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

my @digits = ( 0 .. 9 );

sub count_increasing
{
    my $NUM_DIGITS = shift;

    my $max_digit = $NUM_DIGITS - 1;

    my $total_sum = 0;

    # Count the increasing numbers
    {
        # Contains for each leading digit, the count of numbers that start
        # with that digit and that are increasing.
        my @counts;

        push @counts, [ (1) x @digits ];

        foreach my $digit_idx ( 1 .. $max_digit )
        {
            my @d_counts;

            # A leading digit of 9 can only have 9 as its next digit,
            # because 98, 97, etc. will be decreasing or bouncy.
            # 8$D$N can have either 8 or 9 as $D.
            # 0 can have them all.
            my $digit_sum = 0;
            foreach my $d ( reverse @digits )
            {
                $digit_sum += $counts[-1][$d];
                push @d_counts, ( 0 + $digit_sum );
            }

            # print "For $digit_idx : ", join(",", reverse @d_counts ), "\n";

            push @counts, [ reverse @d_counts ];
        }

        foreach my $c ( @{ $counts[-1] } )
        {
            $total_sum += $c;
        }
    }

    # We don't need to count the zero.
    return $total_sum - 1;
}

sub count_decreasing
{
    my $NUM_DIGITS = shift;

    my $max_digit = $NUM_DIGITS - 1;

    my $total_sum = 0;

    # Count the decreasing numbers
    #
    # Plan:
    # -----
    #
    # A decreasing number is 00000000000000000000$D[$N]...$D[2]$D[1]$D[0]
    # where for every $I $D[$I+1] > $D[$I].
    #
    # For N = 1 the decreasing numbers are 0-9.
    # For N = 2 the decreasing numbers are 0-9,10,11,20,21,22,30,31,32,33,...
    # For N = 3 the decreasing numbers are
    my @counts;

    {
        my @d_counts = ( (1) x @digits );
        push @counts, \@d_counts;

        foreach my $d_c ( @d_counts[ 1 .. 9 ] )
        {
            $total_sum += $d_c;
        }
    }

    foreach my $digit_idx ( 1 .. $max_digit )
    {
        my @d_counts;

        my $digit_sum = 0;

        foreach my $d (@digits)
        {
            $digit_sum += $counts[-1][$d];
            push @d_counts, ( 0 + $digit_sum );
        }

        push @counts, ( \@d_counts );

        # print "For $digit_idx : ", join(",", reverse @d_counts ), "\n";

        foreach my $d_c ( @d_counts[ 1 .. 9 ] )
        {
            $total_sum += $d_c;
        }
    }

    return $total_sum;
}

sub calc_num_non_bouncy
{
    my $NUM_DIGITS = shift;

    my $max_digit = $NUM_DIGITS - 1;

    my $total_sum =
        count_increasing($NUM_DIGITS) + count_decreasing($NUM_DIGITS);

    # Remove one count of the numbers that are both increasing and
    # decreasing i.e: numbers with all digits the same.
    foreach my $num_digits ( 0 .. $max_digit )
    {
        $total_sum -= 9;
    }

    return $total_sum;
}

sub trace
{
    my $NUM_DIGITS = shift;

    print "Both($NUM_DIGITS) = ", calc_num_non_bouncy($NUM_DIGITS), "\n";
    print "Inc($NUM_DIGITS) = ",  count_increasing($NUM_DIGITS),    "\n";
    print "Dec($NUM_DIGITS) = ",  count_decreasing($NUM_DIGITS),    "\n";

    return;

    my ( $inc_count, $dec_count, $both_count );
    for my $n ( 1 .. ( 10**$NUM_DIGITS - 1 ) )
    {
        my $s = join "", sort { $a <=> $b } split //, $n;

        my $both_offset = 0;
        if ( $n eq $s )
        {
            $inc_count++;
            $both_offset = 1;
        }
        if ( $n eq reverse($s) )
        {
            $both_offset = 1;
            $dec_count++;
        }
        $both_count += $both_offset;
    }

    print "Real_Count_Both($NUM_DIGITS) = $both_count\n";
    print "Real_Count_Inc($NUM_DIGITS) = $inc_count\n";
    print "Real_Count_Dec($NUM_DIGITS) = $dec_count\n";

    return;
}

# trace(1);
# trace(2);
# trace(3);
# trace(4);

trace(6);
trace(10);
trace(100);

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
