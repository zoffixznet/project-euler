#!/usr/bin/perl

use strict;
use warnings;

use integer;
# use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

use Euler156_V2 qw(calc_f_delta_for_leading_digits calc_f_delta f_d_n);

my @found = (map { +{} } 0 .. 9);

sub check
{
    my ($d, $first, $f_first, $last, $f_last) = @_;

    # print "[@_]\n";
    if ($first >= $last)
    {
        if ($f_first == $first)
        {
            $found[$d]{$first} = 1;
        }
    }
    elsif ($last == $first+1)
    {
        check($d, $first, $f_first, $first, $f_first);
        check($d, $last, $f_last, $last, $f_last);
    }
    else
    {
        my $mid = (($first+$last)>>1);

        if ($mid == $first)
        {
            $mid++;
        }
        if ($mid < $first or $mid > $last)
        {
            die "Foo";
        }
        my $f_mid = f_d_n($d, $mid);

        if (not( $f_first > $mid or $f_mid < $first ))
        {
            check($d, $first, $f_first, $mid, $f_mid);
        }

        if (not( $f_mid > $last or $f_last < $mid ))
        {
            check($d, $mid, $f_mid, $last, $f_last);
        }
    }

    return;
}

my $total_sum = 0;

for my $d (1 .. 9)
{
    my $first = 1;
    my $last = ($first << 1);
    my $continue = 1;
    while ($continue)
    {
        my $f_first = f_d_n($d, $first);
        my $f_last = f_d_n($d, $last);

        if ($f_first > $last)
        {
            $continue = 0;
            print "Cannot be (f_d_n > n) in range [$first .. $last]\n";
        }
        elsif ($f_last < $first)
        {
            print "Cannot be (f_d_n < n) in range [$first .. $last]\n";
        }
        else
        {
            print "I don't know in range [$first .. $last]\n";
            check($d, $first, $f_first, $last, $f_last);
        }
    }
    continue
    {
        $first = $last;
        $last <<= 1;
    }

    my $sum = 0;
    for my $k (keys(%{$found[$d]}))
    {
        $sum += $k;
    }

    print "s($d) = $sum\n";
    $total_sum += $sum;
}
print "total_sum = $total_sum\n";
