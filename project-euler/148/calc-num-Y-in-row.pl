#!/usr/bin/perl

use strict;
use warnings;

use integer;
# use Math::BigInt lib => 'GMP', ':constant';

my $BASE = 7;

sub calc_num_Y_in_row_n
{
    my $n_proto = shift;
    my $n = $n_proto - 1;

    my @digits;

    # my $digit_n = $n->copy();
    my $digit_n = $n;
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

    my $recurse;

    $recurse = sub {
        my ($d_len) = @_;

        if ($d_len <= 1)
        {
            return 0;
        }
        else
        {
            my $big_Y_num = ($digits[$d_len-1]->{power}-1-$digits[$d_len-2]->{total_mod});
            my $big_Y_total = $big_Y_num * $digits[$d_len-1]->{d};

            return $big_Y_total + ($digits[$d_len-1]->{d}+1) * $recurse->($d_len-1);      }
    };

    return $recurse->(scalar( @digits ));
}

foreach my $n (@ARGV)
{
    print "${n}: ", calc_num_Y_in_row_n($n), "\n";
}
