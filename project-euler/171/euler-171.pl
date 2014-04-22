#!/usr/bin/perl

use strict;
use warnings;

use integer;
# use Math::GMP qw(:constant);

use List::Util qw(sum reduce);
use List::MoreUtils qw(any);

my @sq;

sub sq
{
    my ($n) = @_;
    return $n*$n;
}

my $LIMIT = sq(9) * 19;

{
    my $n = 0;

    my $sq = sq($n);
    while ($sq <= $LIMIT)
    {
        push @sq, $sq;
        $sq = sq(++$n);
    }
}

my @facts = (1);

for my $n (1 .. 20)
{
    push @facts, $n*$facts[-1];
}

sub nCr
{
    my ($n, $k) = @_;

    if ($n < $k)
    {
        die "N=$n K=$k";
    }
    return $facts[$n] / $facts[$n-$k] * $facts[$k];
}

sub _count_permutations
{
    my ($n, $k_s) = @_;

    my $p = 1;

    foreach my $k (@$k_s)
    {
        $p *= $facts[$k];
    }

    return ($facts[$n] / $p);
}

sub square_sum_combinations
{
    my ($COUNT_DIGITS, $trailing_sq_sum, $cb) = @_;

    my $trail_cb;

    $trail_cb = sub {
        my ($digits, $num, $next_digit, $sq, $remaining_sum) = @_;

        if ($num == $COUNT_DIGITS)
        {
            if ($remaining_sum)
            {
                return;
            }
            $cb->($digits);

            return;
        }
        elsif ($sq > $remaining_sum)
        {
            my $next = $next_digit - 1;
            return $trail_cb->($digits, $num, $next, $sq[$next], $remaining_sum);
        }
        elsif ($remaining_sum > $sq * ($COUNT_DIGITS - $num))
        {
            return;
        }
        elsif ($next_digit == 0)
        {
            my @new_digits = @$digits;
            if (@new_digits and $new_digits[-1][0] != 0)
            {
                push @new_digits, [0, 0];
            }
            else
            {
                $new_digits[-1] = [@{$new_digits[-1]}];
            }
            $new_digits[-1][1] += $COUNT_DIGITS-$num;

            return $trail_cb->(
                \@new_digits,
                $COUNT_DIGITS,
                0,
                0,
                0
            );
        }
        else
        {
            for my $next (reverse (0 .. $next_digit))
            {
                my @new_digits = @$digits;
                if (@new_digits and $new_digits[-1][0] == $next)
                {
                    $new_digits[-1] = [$next, $new_digits[-1][1]+1];
                }
                else
                {
                    push @new_digits, [$next, 1];
                }
                my $new_sq = $sq[$next];
                my $new_remaining_sum = $remaining_sum - $new_sq;

                if ($new_remaining_sum >= 0)
                {
                    $trail_cb->(
                        \@new_digits,
                        $num+1,
                        $next,
                        $new_sq,
                        $new_remaining_sum,
                    );
                }
            }
        }
    };

    $trail_cb->(
        [],
        0,
        9,
        $sq[9],
        $trailing_sq_sum,
    );

    return;
}

my $COUNT_TRAILING_DIGITS = 9;
my $MOD = 1_000_000_000;
my $COUNT_ALL_DIGITS = 19;

# Temporary: remove later.
$COUNT_TRAILING_DIGITS = 2;
$MOD = 100;
$COUNT_ALL_DIGITS = 5;

my $COUNT_LEADING_DIGITS = $COUNT_ALL_DIGITS - $COUNT_TRAILING_DIGITS;

my $total_mod = 0;
my $INC = 0 + ('1' x $COUNT_TRAILING_DIGITS);
my $COUNT_FACT = $COUNT_TRAILING_DIGITS - 1;

STDOUT->autoflush(1);

foreach my $trailing_sq_sum (1 .. $sq[9] * $COUNT_TRAILING_DIGITS)
{
    print "trailing_sq_sum = $trailing_sq_sum\n";

    # First calculate the trailing mod.
    my $trailing_mod = 0;

    square_sum_combinations(
        $COUNT_TRAILING_DIGITS,
        $trailing_sq_sum,
        sub {
            my ($digits) = @_;

            $trailing_mod += (
                $INC *
                sum(
                    map { $_->[0]*$_->[1] } @$digits
                ) * $facts[$COUNT_FACT]
            ) / (
                reduce { $a * $b } (@facts[map { $_->[1] } @$digits])
            );
            $trailing_mod %= $MOD;
            # print "$trailing_sq_sum: ", join(",", map { "$_->[1]*$_->[0]" } @$digits), "\n";

            # Sanity checks.
            if (sum ( map { $_->[1] } @$digits ) != $COUNT_TRAILING_DIGITS)
            {
                die "Foo";
            }

            return;
        }
    );

    if ($trailing_mod)
    {
        my $leading_count = 0;

        foreach my $all_digits_sq_sum (@sq)
        {
            if ($all_digits_sq_sum > $trailing_sq_sum)
            {
                square_sum_combinations(
                    $COUNT_LEADING_DIGITS,
                    $all_digits_sq_sum - $trailing_sq_sum,
                    sub {
                        my ($digits) = @_;

                        $leading_count += _count_permutations(
                            $COUNT_LEADING_DIGITS,
                            [map { $_->[1]} @$digits],
                        );

                        if (sum ( map { $_->[1] } @$digits ) != $COUNT_LEADING_DIGITS)
                        {
                            die "Bar";
                        }
                        return;
                    }
                );
            }
        }

        ($total_mod += ($leading_count * $trailing_mod)) %= $MOD;
    }
}

printf "Last digits = <%09d>\n", $total_mod;

# Brute force
if (1)
{
    my $sum = 0;
    for my $n (1 .. '9' x $COUNT_ALL_DIGITS)
    {
        my $sq_sum = sum(map { $sq[$_] } split//,$n);
        if (any { $_ == $sq_sum } @sq)
        {
            $sum += $n;
        }
    }
    print "Sum=<$sum>\n";
}
