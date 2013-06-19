#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

sub fact
{
    return shift->copy->bfac;
}

sub nCr
{
    my ($n, $k) = @_;
    $n += 0;
    $k += 0;
    return fact($n) / (fact($n-$k) * fact($k));
}

my $BASE = 7;

sub calc_num_Y_in_row_n
{
    my $n_proto = shift;
    my $n = $n_proto - 1;

    my $recurse;

    my $n_from_digits;

    $n_from_digits = sub {
        my $aref = shift;

        if (! @$aref)
        {
            return 0;
        }
        return $aref->[0] + $BASE * $n_from_digits->([ @$aref[1 .. $#$aref] ]);
    };

    $recurse = sub {
        my ($digits_aref) = @_;

        my @digits = @$digits_aref;

        if (@digits <= 1)
        {
            return 0;
        }
        elsif (@digits == 2)
        {
            return ($BASE-1-$digits[0]->{d}) * $digits[1]->{d};
        }
        elsif (@digits == 3)
        {
            my $big_Y_num = ($digits[-1]->{power}-1-$digits[-2]->{total_mod});
            my $big_Y_total = $big_Y_num * $digits[-1]->{d};
            # my $remaining_n = $digits[-1]->{total_mod} - $big_Y_total;

            return $big_Y_total + ($digits[-1]->{d}+1) * $recurse->([@digits[0 .. $#digits-1]]);
        }
        else
        {
            die "Cannot handle.";
        }
    };

    my @digits;

    my $digit_n = $n->copy();
    my $power = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ($digit_n % $BASE);
        $total_mod = $total_mod + $digit * $power;
        push @digits, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $BASE;
        $power *= $BASE;
    }

    return $recurse->([@digits]);
}

foreach my $n (@ARGV)
{
    print "${n}: ", calc_num_Y_in_row_n($n), "\n";
}
