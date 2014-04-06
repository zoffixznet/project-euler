#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(first sum);

my $DEBUG = 1;

sub my_none(&;@)
{
    my $code_ref = shift;

    foreach my $elem (@_)
    {
        local $_ = $elem;
        if ($code_ref->($_))
        {
            return;
        }
    }

    return 1;
}

sub calc_P
{
    my ($MIN, $MAJ) = @_;

    my $total_count = 0;

    # For row == 1.
    $total_count += $MAJ;

    my %found;

    if ($DEBUG)
    {
        %found = (map { $_ => 1 } (1 .. $MAJ));
    }

    my @found_in_next;

    foreach my $row_idx (2 .. $MIN)
    {
        my $max = $row_idx * $MAJ;
        my $count = $MAJ;

        foreach my $prev_row (1 .. $row_idx-1)
        {
            my $prev_max = $prev_row * $MAJ;

            my $delta;
            if ($prev_row == 1)
            {
                $delta = int($prev_max / $row_idx);
            }
            else
            {
                $delta = ($found_in_next[$row_idx][$prev_row] // 0);
            }

            if ($DEBUG)
            {
                my @expected_delta =
                (grep { ($found{$_} // (-1)) == $prev_row } map { $_ * $row_idx } 1 .. $MAJ);

                if ($delta != @expected_delta)
                {
                    die "Row == $row_idx ; Prev_Row == $prev_row. There are $delta whereas there should be " . @expected_delta . "!\n";
                }
            }

            $count -= $delta;

            if ($count < 0)
            {
                die "Count is less than 0! (\$count=$count)\n";
            }
        }

        if ($DEBUG)
        {
            my @new = (grep { !exists($found{$_}) } map { $row_idx * $_ } 1 .. $MAJ);

            if (@new != $count)
            {
                die "Row == $row_idx. There are $count whereas there should be " . @new . "!\n";
            }

            %found = (%found, map { $_ => $row_idx } @new);
        }

        foreach my $next_row ($row_idx+1 .. $MIN)
        {
            for my $i (1 .. $MAJ)
            {
                my $prod = $i*$row_idx;
                if ($prod > $MAJ and
                    ($prod % $next_row == 0) and
                    (my_none { $prod <= $MAJ*$_ and $prod % $_ == 0 } 2 .. $row_idx-1)
                )
                {
                    $found_in_next[$next_row][$row_idx]++;
                }
            }
        }

        $total_count += $count;
    }

    return $total_count;
}

sub my_test
{
    my ($MIN, $MAJ, $expected) = @_;

    my $got = calc_P($MIN, $MAJ);

    print "P($MIN, $MAJ) = $got (should be $expected)\n";
}

my_test(3, 4, 8);
my_test(64, 64, 1263);
my_test(12, 345, 1998);
my_test(32, (('1'.('0'x15))+0), 13826382602124302);

