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
# $sums[$num_digits][$sum][$leading_digit] = [$count, $sum]
my @S;

for my $d (0 .. 9)
{
    $S[1][$d][$d] = { count => 1, sum => $d};
}
for my $num_digits (2 .. 26)
{
    my $prev = $num_digits - 1;

    for my $leading_digit (0 .. 9)
    {
        while (my ($prev_sum, $prev_leads_aref) = each(@{$S[$prev]}))
        {
            while (my ($prev_lead_digit, $prev_stats) = each(@$prev_leads_aref))
            {
                if (defined($prev_stats))
                {
                    my $record =
                    $S[$num_digits][$prev_sum + $leading_digit][$leading_digit]
                    //= { count => 0, sum => 0, };

                    $record->{count} += $prev_stats->{count};
                    $record->{sum} += $prev_stats->{sum} + $prev_stats->{count} * $leading_digit * (10 ** $prev);
                }
            }
        }
    }
}


