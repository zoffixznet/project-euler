#!/usr/bin/perl

use strict;
use warnings;

use Math::BigInt lib => 'GMP', ':constant';

use List::Util qw(sum);
use List::MoreUtils qw();

sub is_int_ok
{
    my ($n) = @_;
    return ((join "", sort { $a cmp $b } split//, "$n") !~ /([0-9])\1\1\1/);
}

sub test_is_int_ok
{
    my ($n) = @_;

    print "N = $n ; Tested: ", (is_int_ok($n) ? "True" : "False"), "\n";
}

if (0)
{
test_is_int_ok("123123123");
test_is_int_ok("1231231231");
test_is_int_ok("111300");
test_is_int_ok("123456789123456789");
test_is_int_ok("123456789012345678901234567890");
test_is_int_ok("1234567890123456789012345678901");
}

sub solve_for_n_brute_force
{
    my ($NUM_DIGITS) = @_;

    my $count = 0;

    my $i = Math::BigInt->new('1' . ('0' x ($NUM_DIGITS-1)));
    my $max = Math::BigInt->new('9' x $NUM_DIGITS);

    while ($i <= $max)
    {
        if (is_int_ok($i))
        {
            $count++;
        }
    }
    continue
    {
        $i++;
    }

    return $count;
}

sub fact
{
    return Math::BigInt->new(shift)->copy->bfac;
}

sub solve_using_combinatorics
{
    my ($NUM_DIGITS) = @_;

    my $NUM_DIGITS_MIN_1 = $NUM_DIGITS - 1;

    # We'll assume (without loss of generality) that the leading digit is 1.
    # Later we'll multiply by 9.
    my $count_div_9 = 0;

    foreach my $extra_1s (0 .. 2)
    {
        my $total_1s = 1+$extra_1s;
        my $no_1s_digits = $NUM_DIGITS - $total_1s;
        THREES:
        for my $count_threes (0 .. 9)
        {
            my $remaining_digits_after_threes = 10 - 1 - $count_threes;
            my $remaining_positions_after_threes
                = $no_1s_digits - 3 * $count_threes;

            if ($remaining_positions_after_threes < 0)
            {
                last THREES;
            }
            TWOS:
            for my $count_twos (0 .. $remaining_digits_after_threes)
            {
                my $remaining_digits_after_twos = $remaining_digits_after_threes - $count_twos;
                my $remaining_positions_after_twos = $remaining_positions_after_threes - 2 * $count_twos;

                if ($remaining_positions_after_twos < 0)
                {
                    last TWOS;
                }

                my $count_ones = $remaining_positions_after_twos;
                my $count_zeros = $remaining_digits_after_twos - $count_ones;

                if ($count_zeros < 0)
                {
                    last TWOS;
                }

                # OK, now we have the extra_1s, count_threes, count_twos
                # count_ones and count_zeros. We can calculate the number
                # of permutations

                my $num_perms =
                    fact(10 - 1) /
                    ( fact($count_threes) * fact($count_twos)
                        * fact($count_ones) * fact($count_zeros) )
                    * fact($NUM_DIGITS_MIN_1) /
                    (
                        (fact(3) ** $count_threes)
                        * (fact(2) ** $count_twos)
                        * fact($extra_1s)
                    );

                $count_div_9 += $num_perms;
            }
        }
    }

    return ($count_div_9 * 9);
}

sub display_combi_N
{
    my ($N) = @_;
    print "N = $N ; CombiForceCount = < ", solve_using_combinatorics($N), " >\n";

    return;
}
sub test_N
{
    my ($N) = @_;

    print "N = $N ; BruteForceCount = < ", solve_for_n_brute_force($N), " >\n";
    display_combi_N($N);

    return;
}

if (0)
{
foreach my $N (1 .. 6)
{
    test_N($N);
}
}

if (1)
{
    display_combi_N(18);
}
