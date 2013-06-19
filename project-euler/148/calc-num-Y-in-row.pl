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

    my @digits;

    my $digit_n = $n->copy();
    while ($digit_n)
    {
        push @digits, $digit_n % $BASE;
        $digit_n /= $BASE;
    }

    if (@digits <= 1)
    {
        return 0;
    }
    elsif (@digits == 2)
    {
        return ($BASE-1-$digits[0]) * $digits[1];
    }
    else
    {
        die "Cannot handle.";
    }
}

my $n = shift(@ARGV);

print calc_num_Y_in_row_n($n), "\n";
