#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(product sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my @factorials = (1);
for my $n (1 .. 10)
{
    push @factorials, $factorials[-1] * $n;
}

my ($MAX_DIGIT) = @ARGV;

my $num_half_digits = $MAX_DIGIT+1;
my $num_digits = $num_half_digits * 2;

my $count = 0;

my $EXPECTED_SUM = (((0 + $MAX_DIGIT) * $num_half_digits) >> 1);
for my $leading_digit (1 .. $MAX_DIGIT)
{
    my @digits_counts = ((2) x $num_half_digits);

    $digits_counts[$leading_digit]--;

    my $rec;

    $rec = sub {
        my ($start_from, $num_remaining, $digits_c, $sum_left) = @_;

        if ($start_from > $MAX_DIGIT)
        {
            return;
        }

        if ($sum_left < 0)
        {
            return;
        }

        if ($sum_left == 0 and $num_remaining and $start_from)
        {
            return;
        }

        if ($num_remaining == 0)
        {
            if ($sum_left > 0)
            {
                return;
            }
            $count += $factorials[$num_half_digits-1] * $factorials[$num_half_digits] / product(map { $factorials[$digits_c->[$_]] * $factorials[$digits_counts[$_]-$digits_c->[$_]] } keys(@digits_counts));

            return;
        }


        C:
        for my $c (0 .. $digits_c->[$start_from])
        {
            if ($num_remaining < $c)
            {
                last C;
            }
            my @new = @$digits_c;
            $new[$start_from] -= $c;
            $rec->(
                $start_from+1,
                $num_remaining-$c,
                (\@new),
                $sum_left - ($start_from*$c)
            );
        }
    };

    $rec->(0, $num_half_digits-1, \@digits_counts, ($EXPECTED_SUM-$leading_digit));
}

print "Count = $count\n";
