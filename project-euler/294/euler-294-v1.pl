#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %for_n = (0 => {0 => {0 => 1}});

sub exp_mod
{
    my ($MOD, $b, $e) = @_;

    if ($e == 0)
    {
        return 1;
    }

    my $rec_p = exp_mod($MOD, $b, ($e >> 1));

    my $ret = $rec_p * $rec_p;

    if ($e & 0x1)
    {
        $ret *= $b;
    }

    return ($ret % $MOD);
}

sub inc
{
    my ($n) = @_;

    my $old_rec = $for_n{$n};

    my $new_n = $n + 1;

    my $new_rec = +{};

    my $BASE_MOD = exp_mod(23, 10, $new_n);

    while (my ($old_count_digits, $old_mod_counts) = each (%{$old_rec}))
    {
        while (my ($old_mod, $old_count) = each(%$old_mod_counts))
        {
            for my $new_digit (0 .. min(9, 23-$old_count_digits))
            {
                (($new_rec->{$old_count_digits + $new_digit}
                        ->{($old_mod + $BASE_MOD * $new_digit) % 23}
                        //= 0) += $old_count)
                %= 1_000_000_000;
            }
        }
    }

    $for_n{$new_n} = $new_rec;

    return;
}

my $COUNT_DIGITS = 23;
my $HIGH_MOD = 22;

sub double
{
    my ($n) = @_;

    my $new_n = ($n << 1);

    my $old_rec = $for_n{$n};

    my $BASE_MOD = exp_mod(23, 10, $n);

    my $new_rec = +{};

    # cd == count_digits
    foreach my $cd_low (0 .. $COUNT_DIGITS)
    {
        my $mod_counts_low = $old_rec->{$cd_low};

        foreach my $mod_low (0 .. $HIGH_MOD)
        {
            my $low_count = $mod_counts_low->{$mod_low} // 0;

            foreach my $cd_high (0 .. $COUNT_DIGITS-$cd_low)
            {
                my $mod_counts_high = $old_rec->{$cd_high};

                foreach my $proto_mod_high (0 .. $HIGH_MOD)
                {
                    my $high_count = $mod_counts_high->{$proto_mod_high} // 0;

                    (($new_rec->{
                                $cd_low + $cd_high
                            }
                            ->{
                                ($mod_low + $BASE_MOD * $proto_mod_high)
                                %
                                23
                            } //= 0) += ($high_count * $low_count))
                    %= 1_000_000_000
                    ;

                }
            }
        }
    }

    $for_n{$new_n} = $new_rec;

    return;
}

sub calc
{
    my ($n) = @_;

    if (!exists ($for_n{$n}))
    {
        if ($n & 0x1)
        {
            calc($n-1);
            inc($n-1);
        }
        else
        {
            my $x = ($n >> 1);
            calc($x);
            double($x);
        }
    }

    return;
}

# for my $n (1 .. 42)
# {
#    inc($n-1);
# }
#
calc(42);
calc(9);

print "Result[9] = $for_n{9}{23}{0}\n";
print "Result[42] = $for_n{42}{23}{0}\n";

my $SOUGHT = 11 ** 12;
calc( $SOUGHT );

print "Result[11 ** 12] = $for_n{$SOUGHT}{23}{0}\n";
