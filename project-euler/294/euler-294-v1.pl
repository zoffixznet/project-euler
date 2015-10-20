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

sub inc
{
    my ($n, $old_rec) = @_;

    my $new_rec = [];

    my $BASE_MOD = exp_mod(23, 10, $n+1);

    while (my ($old_count_digits, $old_mod_counts) = each (@$old_rec))
    {
        while (my ($old_mod, $old_count) = each(@$old_mod_counts))
        {
            for my $new_digit (0 .. min(9, 23-$old_count_digits))
            {
                (($new_rec->[$old_count_digits + $new_digit]
                        ->[($old_mod + $BASE_MOD * $new_digit) % 23]
                        //= 0) += $old_count)
                %= $RESULT_MOD;
            }
        }
    }

    return $new_rec;
}

my $COUNT_DIGITS = 23;
my $HIGH_MOD = 22;

sub double
{
    my ($n, $old_rec) = @_;

    my $BASE_MOD = exp_mod(23, 10, $n);

    my $new_rec = [];

    # cd == count_digits
    foreach my $low_cd (0 .. $COUNT_DIGITS)
    {
        my $low_mod_counts = $old_rec->[$low_cd];

        foreach my $low_mod (0 .. $HIGH_MOD)
        {
            my $low_count = $low_mod_counts->[$low_mod] // 0;

            foreach my $high_cd (0 .. $COUNT_DIGITS-$low_cd)
            {
                my $high_mod_counts = $old_rec->[$high_cd];

                foreach my $proto_high_mod (0 .. $HIGH_MOD)
                {
                    my $high_count = $high_mod_counts->[$proto_high_mod] // 0;

                    (($new_rec->[
                                $low_cd + $high_cd
                            ]
                            ->[
                                ($low_mod + $BASE_MOD * $proto_high_mod)
                                %
                                23
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

    if (!exists ($for_n{$n}))
    {
        my $rec = ($n & 0x1) ? +{ 'x' => ($n-1), cb => \&inc }
            : +{ 'x' => ($n >> 1), cb => \&double };
        my $x = $rec->{'x'};
        calc($x);
        $for_n{$n} = $rec->{cb}->($x, $for_n{$x});
    }

    return;
}

sub lookup
{
    my ($n) = @_;

    calc($n);

    return ($for_n{$n}[23][0] // 0);
}

print "Result[9] = @{[lookup(9)]}\n";
print "Result[42] = @{[lookup(42)]}\n";

my $SOUGHT = 11 ** 12;

print "Result[11 ** 12] = @{[lookup($SOUGHT)]}\n";
