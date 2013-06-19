#!/usr/bin/perl

use strict;
use warnings;

use 5.016;

use List::Util qw(sum);
use integer;
# use Math::BigInt lib => 'GMP', ':constant';

my $BASE = 7;

sub calc_num_Y_in_row_n
{
    my $n_proto = shift;
    my $n = $n_proto - 1;

    my @D;

    # my $digit_n = $n->copy();
    my $digit_n = $n;
    my $power = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ($digit_n % $BASE);
        $total_mod = $total_mod + $digit * $power;
        push @D, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $BASE;
        $power *= $BASE;
    }

    my $recurse = sub {
        my ($d_len) = @_;

        if ($d_len <= 0)
        {
            return 0;
        }
        else
        {
            my $big_Y_num = ($D[$d_len]->{power}-1-$D[$d_len-1]->{total_mod});
            my $big_Y_total = $big_Y_num * $D[$d_len]->{d};

            return $big_Y_total + ($D[$d_len]->{d}+1) * __SUB__->($d_len-1);
        }
    };

    return $recurse->($#D);
}

sub calc_num_Y_in_7_consecutive_rows
{
    my $n_proto = shift;
    my $n = $n_proto - 1;

    my @D;

    # my $digit_n = $n->copy();
    my $digit_n = $n;
    my $power = 1;
    my $total_mod = 0;
    while ($digit_n)
    {
        my $digit = ($digit_n % $BASE);
        $total_mod = $total_mod + $digit * $power;
        push @D, { d => $digit, power => $power, total_mod => $total_mod };
        $digit_n /= $BASE;
        $power *= $BASE;
    }

    if ($D[0]{d} != 0)
    {
        die "Cannot proceeed with '$n'.";
    }

    my $recurse = sub {
        my ($d_len) = @_;

        if ($d_len <= 0)
        {
            return 0;
        }
        else
        {
            my $big_Y_num = $BASE *
                ($D[$d_len]->{power} - 1 - $D[$d_len-1]->{total_mod} - ($BASE-1))
                + (($BASE *($BASE-1))>>1);

            my $big_Y_total = $big_Y_num * $D[$d_len]->{d};

            return $big_Y_total + ($D[$d_len]->{d}+1) * __SUB__->($d_len-1);
        }
    };

    return $recurse->($#D);
}

if ($ENV{RUN})
{
    my $LIMIT = 1_000_000_000;
    my $limit = $LIMIT / $BASE;
    my $sum = 0;

    my $n;
    foreach my $d (1 .. $limit)
    {
        $n = $d * $BASE + 1;
        $sum += calc_num_Y_in_7_consecutive_rows($n);

        if ($d % 10_000 == 0)
        {
            print "Reached $n [Sum == $sum]\n";
        }
    }

    $sum += sum(map { calc_num_Y_in_row_n($_) } ($n .. $LIMIT));
    print "Final Sum == $sum\n";
}
elsif ($ENV{TEST})
{

    foreach my $x (1 .. 10_000)
    {
        my $n = $x * 7 + 1;
        my $exp = sum(map { calc_num_Y_in_row_n($_) } $n .. $n+6);
        my $got = calc_num_Y_in_7_consecutive_rows($n);
        print "Expected: $exp\nGot: $got\n";
        if ($got != $exp)
        {
            die "Failure at $n.";
        }
    }
}
else
{
    foreach my $n (@ARGV)
    {
        print "${n}: ",
        ($ENV{OPT7} ?
            calc_num_Y_in_7_consecutive_rows($n)
            : calc_num_Y_in_row_n($n)
        ),
        "\n";
    }
}
