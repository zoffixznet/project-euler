#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

# S = sums.
# $sums[$num_digits][$sum][$leading_digit_truth] = [$count, $sum]
my @S;

for my $d (0 .. 9)
{
    $S[1][$d][($d != 0) ? 1 : 0] = [1,$d];
}

my $COUNT = 0;
my $SUM = 1;

my $pow10 = 10;
for my $num_digits (2 .. 26)
{
    my $prev = $num_digits - 1;

    my $pow10times = 0;
    for my $leading_digit (0 .. 9)
    {
        my $d_t = (($leading_digit != 0) ? 1 : 0);
        while (my ($prev_sum, $prev_leads_aref) = each(@{$S[$prev]}))
        {
            while (my ($prev_lead_digit, $prev_stats) = each(@$prev_leads_aref))
            {
                if (defined($prev_stats))
                {
                    my $record =
                    (
                        $S[$num_digits][$prev_sum + $leading_digit][$d_t]
                        //= [0,0]
                    );

                    $record->[$COUNT] += $prev_stats->[$COUNT];
                    $record->[$SUM] += $prev_stats->[$SUM] + $prev_stats->[$COUNT] * $pow10times;
                }
            }
        }
    }
    continue
    {
        $pow10times += $pow10;
    }
}
continue
{
    $pow10 *= 10;
}


