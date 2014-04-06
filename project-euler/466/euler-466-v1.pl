#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(first sum);
use List::MoreUtils qw();

sub gcd
{
    my ($n, $m) = @_;

    if ($m > $n)
    {
        ($n, $m) = ($m, $n);
    }

    while ($m > 0)
    {
        ($n, $m) = ($m, $n%$m);
    }

    return $n;
}

sub calc_P
{
    my ($MIN, $MAJ) = @_;

    my $total_count = 0;

    # For row == 1.
    $total_count += $MAJ;

    foreach my $row_idx (2 .. $MIN)
    {
        my $max = $row_idx * $MAJ;
        my $count = $MAJ;

        foreach my $prev_row (1 .. $row_idx-1)
        {
            my $prev_max = $prev_row * $MAJ;

            if ($prev_row == 1)
            {
                $count -= int($prev_max / $row_idx);
            }
            else
            {
                my $prev_row__max_divisor =
                    first { $prev_row % $_ == 0 } reverse(1 .. $prev_row-1)
                    ;

                my $prev_min = ($prev_row__max_divisor * $MAJ);

                # The lcm.
                my $step = ($prev_row * $row_idx / gcd($prev_row, $row_idx));

                # Round up.
                my $prev_min_pivot = ($prev_min % $step == 0 ? $prev_min
                    : ($prev_min + ($step - ($prev_min % $step)))
                );

                # Round down.
                my $prev_max_pivot = ($prev_max % $step == 0 ? $prev_max
                    : ($prev_max - ($prev_max % $step))
                );

                $count -= (($prev_max_pivot - $prev_min_pivot) / $step + 1);
            }
        }

        $total_count += $count;
    }

    return $total_count;
}

print "P(3,4) = ", calc_P(3, 4), " (should be 8)\n";
