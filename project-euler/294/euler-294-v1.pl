#!/usr/bin/perl

use strict;
use warnings;

use integer;
use bytes;

use Math::GMP ':constant';

use List::Util qw(min sum);
use List::MoreUtils qw();

STDOUT->autoflush(1);

my %for_n = (0 => {0 => {0 => 1}});

sub inc
{
    my ($n) = @_;

    my $old_rec = $for_n{$n};

    my $new_n = $n + 1;

    if (!exists($for_n{$new_n})) {
        my $new_rec = +{};

        my $BASE_MOD = Math::GMP->new(10)->powm_gmp($new_n, 23);

        while (my ($old_count_digits, $old_mod_counts) = each (%{$old_rec}))
        {
            while (my ($old_mod, $old_count) = each(%$old_mod_counts))
            {
                for my $new_digit (0 .. min(9, 23-$old_count_digits))
                {
                    ($new_rec->{$old_count_digits + $new_digit}
                        ->{($old_mod + $BASE_MOD * $new_digit) % 23}
                        //= Math::GMP->new(0)) += $old_count;
                }
            }
        }
        $for_n{$new_n} = $new_rec;
    }

    return;
}

for my $n (1 .. 42)
{
    inc($n-1);
}

print "Result[1] = $for_n{9}{23}{0}\n";
print "Result[42] = $for_n{42}{23}{0}\n";
