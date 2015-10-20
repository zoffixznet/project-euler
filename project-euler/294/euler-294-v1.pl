#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

# use Math::GMP ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %for_n = (0 => [[1]],);

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

my $RESULT_MOD = 1_000_000_000;
my $DIGITS_SUM = 23;
my $BASE = 23;
my $HIGH_MOD = $BASE - 1;


sub inc
{
    my ($n, $old_rec) = @_;

    my $new_rec = [];

    my $BASE_MOD = exp_mod($BASE, 10, $n+1);

    while (my ($old_digits_sum, $old_mod_counts) = each (@$old_rec))
    {
        for my $new_digit (0 .. min(9, $DIGITS_SUM-$old_digits_sum))
        {
            while (my ($old_mod, $old_count) = each(@$old_mod_counts))
            {
                (($new_rec->[$old_digits_sum + $new_digit]
                        ->[($old_mod + $BASE_MOD * $new_digit) % $BASE]
                        //= 0) += $old_count)
                %= $RESULT_MOD;
            }
        }
    }

    return $new_rec;
}

sub double
{
    my ($n, $old_rec) = @_;

    my $BASE_MOD = exp_mod($BASE, 10, $n);

    my $new_rec = [];

    # ds == digits_sum
    foreach my $low_ds (0 .. $DIGITS_SUM)
    {
        my $low_mod_counts = $old_rec->[$low_ds];

        foreach my $low_mod (0 .. $HIGH_MOD)
        {
            my $low_count = $low_mod_counts->[$low_mod] // 0;

            foreach my $high_ds (0 .. $DIGITS_SUM-$low_ds)
            {
                my $high_mod_counts = $old_rec->[$high_ds];

                foreach my $proto_high_mod (0 .. $HIGH_MOD)
                {
                    my $high_count = $high_mod_counts->[$proto_high_mod] // 0;

                    (($new_rec->[
                                $low_ds + $high_ds
                            ]
                            ->[
                                ($low_mod + $BASE_MOD * $proto_high_mod)
                                %
                                $BASE
                            ] //= 0) += ($high_count * $low_count))
                    %= $RESULT_MOD
                    ;

                }
            }
        }
    }

    return $new_rec;
}

sub calc
{
    my ($n) = @_;

    return $for_n{$n} //= do {
        my $rec = ($n & 0x1) ? +{ 'x' => ($n-1), cb => \&inc }
            : +{ 'x' => ($n >> 1), cb => \&double };
        my $x = $rec->{'x'};
        $rec->{cb}->($x, calc($x));
    };
}

sub lookup
{
    my ($n) = @_;

    return (calc($n)->[$DIGITS_SUM][0] // 0);
}

print "Result[9] = @{[lookup(9)]}\n";
print "Result[42] = @{[lookup(42)]}\n";

my $SOUGHT_EXPR = '11 ** 12';
my $SOUGHT = eval $SOUGHT_EXPR;

print "Result[$SOUGHT_EXPR] = @{[lookup($SOUGHT)]}\n";
