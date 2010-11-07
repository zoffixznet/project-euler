#!/usr/bin/perl

use strict;
use warnings;

use Math::GMP qw(:constant);

=head1 DESCRIPTION

Working from left-to-right if no digit is exceeded by the digit to its left it is called an increasing number; for example, 134468.

Similarly if no digit is exceeded by the digit to its right it is called a decreasing number; for example, 66420.

We shall call a positive integer that is neither increasing nor decreasing a "bouncy" number; for example, 155349.

Clearly there cannot be any bouncy numbers below one-hundred, but just over half of the numbers below one-thousand (525) are bouncy. In fact, the least number for which the proportion of bouncy numbers first reaches 50% is 538.

Surprisingly, bouncy numbers become more and more common and by the time we reach 21780 the proportion of bouncy numbers is equal to 90%.

Find the least number for which the proportion of bouncy numbers is exactly 99%.

=cut

my @digits = (0 .. 9);

sub calc_num_non_bouncy
{
    my $NUM_DIGITS = shift;

    my $max_digit = $NUM_DIGITS - 1;

    my $total_sum = 0;
    # Count the increasing numbers
    {
        # Contains for each leading digit, the count of numbers that start
        # with that digit and that are increasing.
        my @counts;

        push @counts, [(1) x @digits];

        foreach my $digit_idx (1 .. $max_digit)
        {
            my @d_counts;

            # A leading digit of 9 can only have 9 as its next digit,
            # because 98, 97, etc. will be decreasing or bouncy.
            # 8$D$N can have either 8 or 9 as $D.
            # 0 can have them all.
            my $digit_sum = 0;
            foreach my $d (reverse @digits)
            {
                $digit_sum += $counts[-1][$d];
                push @d_counts, (0+$digit_sum);
            }

            push @counts, [reverse @d_counts];
        }

        foreach my $c (@{$counts[-1]})
        {
            $total_sum += $c;
        }
    }

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
    {
        my @counts;

        push @counts, [(1) x @digits];

        foreach my $digit_idx (1 .. $max_digit)
        {
            my @d_counts;

            my $digit_sum = 0;

            foreach my $d (@digits)
            {
                $digit_sum += $counts[-1][$d];
                push @d_counts, (0+$digit_sum);
            }

            push @counts, \@d_counts;
        
            foreach my $d_c (@d_counts[1 .. 9])
            {
                $total_sum += $d_c;
            }
        }
    }

    # Remove one count of the numbers that are both increasing and 
    # decreasing i.e: numbers with all digits the same.
    foreach my $num_digits (1 .. $max_digit)
    {
        $total_sum -= $num_digits * 9;
    }

    return $total_sum;
}

sub trace
{
    my $NUM_DIGITS = shift;

    print "Total($NUM_DIGITS) = ", calc_num_non_bouncy($NUM_DIGITS), "\n";

    return;
}

trace(1);
trace(2);
trace(3);
trace(6);
