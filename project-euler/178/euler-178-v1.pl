#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP;

use List::Util qw(min max sum);
use List::MoreUtils qw();

my @counts;

# start_digit and end_digit signify the range of the encountered digits.
sub get
{
    my ($depth, $last_digit, $start_digit, $end_digit) = @_;

    return \($counts[$depth][$last_digit][$start_digit][$end_digit-$start_digit] //= Math::GMP->new('0'));
}

sub add
{
    my ($depth, $last_digit, $start_digit, $end_digit, $delta) = @_;
    ${get($depth, $last_digit, $start_digit, $end_digit)} += $delta
}

my $init_depth = 1;
for my $digit (1 .. 9)
{
    add($init_depth, $digit, $digit, $digit => 1);
}

my $total_sum = Math::GMP->new('0');
for my $depth ($init_depth+1 .. 40)
{
    my $prev_depth = $depth-1;
    for my $last_digit (0 .. 9)
    {
        for my $start_digit (0 .. 9)
        {
            for my $end_digit ($start_digit .. 9)
            {
                my $val = ${get($prev_depth, $last_digit, $start_digit, $end_digit)};
                if ($val != 0)
                {
                    DELTA:
                    for my $delta (-1, 1)
                    {
                        my $new_digit = $last_digit + $delta;
                        if ($new_digit >= 0 and $new_digit <= 9)
                        {
                            my $new_start_digit = min($start_digit, $new_digit);
                            my $new_end_digit = max($end_digit, $new_digit);

                            add(
                                $depth,
                                $new_digit,
                                $new_start_digit,
                                $new_end_digit,
                                $val
                            );
                        }
                    }
                }
            }
        }
    }

    my $sum = Math::GMP->new('0');
    for my $last_digit (0 .. 9)
    {
        $sum += ${get($depth, $last_digit, 0, 9)};
    }
    print "For depth=$depth Found $sum\n";
    $total_sum += $sum;
}

print "Total Sum = $total_sum\n";
