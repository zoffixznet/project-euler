#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use integer;
# use Math::BigInt lib => 'GMP', ':constant';

my $BASE = 7;

my @digits;

sub calc_num_Y_in_row_n
{
    my $recurse = sub {
        my ($d_len) = @_;

        if ($d_len <= 0)
        {
            return 0;
        }
        else
        {
            my $big_Y_total = ($digits[$d_len]->{power}-1-$digits[$d_len-1]->{total_mod}) * $digits[$d_len]->{d};

            return $big_Y_total + ($digits[$d_len]->{d}+1) * __SUB__->($d_len-1);
        }
    };

    return $recurse->($#digits);
}

my $sum = 0;

push @digits, {d => 1, power => 1, total_mod => 1};
for my $n (1 .. 999_999_999)
{
    $sum += calc_num_Y_in_row_n();

    if ($n % 10_000 == 0)
    {
        print "Reached $n [Sum == $sum]\n";
    }
}
continue
{
    my $l = 0;
    while ($l < @digits && $digits[$l]{d} == $BASE-1)
    {
        $digits[$l]{d} = 0;
        $digits[$l]{total_mod} = 0;
    }
    continue
    {
        $l++;
    }

    if ($l == @digits)
    {
        my $power = $digits[-1]{power}*$BASE;
        push @digits, {d => 1,
            power => $power,
            total_mod => $digits[-1]{total_mod} + $power,
        };
    }
    else
    {
        $digits[$l]{d}++;
        foreach my $digit (@digits[$l..$#digits])
        {
            $digit->{total_mod}++;
        }
    }
}

# foreach my $n (@ARGV)
# {
#     print "${n}: ", calc_num_Y_in_row_n($n+1), "\n";
# }
print "Final Sum == $sum\n";
